/*
 * Copyright (c) 2014-2020 Albert S. <adhocify@quitesimple.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <sys/inotify.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <libgen.h>
#include <inttypes.h>
#include <time.h>
#include <stdbool.h>
#include <stdarg.h>
#include <errno.h>
#include <fnmatch.h>
#include <getopt.h>
#include <ftw.h>
#include <linux/limits.h>
#define BUF_SIZE (sizeof(struct inotify_event) + NAME_MAX + 1) * 1024
#define STREQ(s1, s2) (strcmp(s1, s2) == 0)

#define SCRIPT_PLACE_SPECIFIER "{}" // same as EVENTFILE_PLACEHOLDER for backwards compatibility
#define EVENTFILE_PLACEHOLDER "%eventfilepath%"
#define EVENTSTR_PLACEHOLDER "%eventmaskstr%"

struct watchlistentry
{
	int ifd;
	char *path;
	bool isdir;
	struct watchlistentry *next;
};

struct watchlistentry *watchlist_head = NULL;
struct watchlistentry **watchlist = &watchlist_head;

struct ignorelist
{
	char *ignore;
	struct ignorelist *next;
};

struct ignorelist *ignorelist_head = NULL;
struct ignorelist **ignorelist_current = &ignorelist_head;

/* Write-once globals. Set from process_arguments*/
bool silent = false;
bool noenv = false;
bool fromstdin = false;
bool forkbombcheck = true;
bool daemonize = false;
bool exit_with_child = false;
int awaited_child_exit_code = -1;
bool negate_child_exit_code = false;

uint32_t mask = 0;
char *prog = NULL;
char *path_logfile = NULL;
char **script_arguments = NULL; // options to be passed to script we are calling
size_t n_script_arguments = 0;

void *xmalloc(size_t size)
{
	void *m = malloc(size);
	if(m == NULL)
	{
		perror("malloc");
		exit(EXIT_FAILURE);
	}
	return m;
}

char *xstrdup(const char *s)
{
	char *tmp = strdup(s);
	if(tmp == NULL)
	{
		perror("strdup");
		exit(EXIT_FAILURE);
	}
	return tmp;
}

char *xrealpath(const char *path, char *resolved_path)
{
	char *tmp = realpath(path, resolved_path);
	if(tmp == NULL)
	{
		char *errorstr = strerror(errno);
		fprintf(stderr, "realpath on %s failed: %s\n", path, errorstr);
		exit(EXIT_FAILURE);
	}
	return tmp;
}

char *ndirname(const char *path)
{
	if(path == NULL)
	{
		return xstrdup(".");
	}
	char *c = strdupa(path);
	return xstrdup(dirname(c));
}

char *find_ifd_path(int ifd)
{
	for(struct watchlistentry *lkp = watchlist_head; lkp != NULL; lkp = lkp->next)
	{
		if(lkp->ifd == ifd)
		{
			return lkp->path;
		}
	}
	return NULL;
}

bool is_ignored(const char *filename)
{
	for(struct ignorelist *l = ignorelist_head; l != NULL; l = l->next)
	{
		if(fnmatch(l->ignore, filename, 0) == 0)
		{
			return true;
		}
	}
	return false;
}

bool path_is_directory(const char *path)
{
	struct stat sb;
	int r = stat(path, &sb);
	if(r == -1)
	{
		perror("stat");
		return false;
	}
	return S_ISDIR(sb.st_mode);
}

static inline bool file_exists(const char *path)
{
	return access(path, F_OK) == 0;
}

void add_to_ignore_list(const char *str)
{
	*ignorelist_current = xmalloc(sizeof(struct ignorelist));
	(*ignorelist_current)->ignore = xstrdup(str);

	ignorelist_current = &(*ignorelist_current)->next;
}

void logwrite(const char *format, ...)
{
	if(silent)
	{
		return;
	}
	va_list args;
	va_start(args, format);
	vfprintf(stdout, format, args);
	fflush(stdout);
	va_end(args);
}

void logerror(const char *format, ...)
{
	va_list args;
	va_start(args, format);
	char *prefix = "Error: ";
	char *tmp = alloca(strlen(format) + strlen(prefix) + 1);
	strcpy(tmp, prefix);
	strcat(tmp, format);
	vfprintf(stderr, tmp, args);
	fflush(stderr);
	va_end(args);
}

void watchqueue_add_path(const char *pathname)
{
	*watchlist = xmalloc(sizeof(struct watchlistentry));
	struct watchlistentry *e = *watchlist;
	char *path = xrealpath(pathname, NULL);
	e->ifd = 0;
	e->path = path;
	e->isdir = path_is_directory(pathname);
	e->next = NULL;
	watchlist = &e->next;
}

void create_watches(int fd, uint32_t mask)
{
	for(struct watchlistentry *lkp = watchlist_head; lkp != NULL; lkp = lkp->next)
	{
		int ret = inotify_add_watch(fd, lkp->path, mask);
		if(ret == -1)
		{
			perror("inotify_add_watch");
			exit(EXIT_FAILURE);
		}

		lkp->ifd = ret;
	}
}

bool redirect_stdout(const char *outfile)
{
	int fd = open(outfile, O_CREAT | O_WRONLY | O_APPEND, S_IRUSR | S_IWUSR);
	if(fd == -1)
	{
		perror("open");
		return false;
	}

	if(dup2(fd, 1) == -1 || dup2(fd, 2) == -1)
	{
		perror("dup2");
		return false;
	}

	return true;
}

const char *mask_to_names(int mask)
{
	static char ret[1024];
	size_t n = sizeof(ret) - 1;
	if(mask & IN_ATTRIB)
	{
		strncat(ret, "IN_ATTRIB,", n);
	}
	if(mask & IN_OPEN)
	{
		strncat(ret, "IN_OPEN,", n);
	}
	if(mask & IN_CLOSE)
	{
		strncat(ret, "IN_CLOSE,", n);
	}
	if(mask & IN_CLOSE_NOWRITE)
	{
		strncat(ret, "IN_CLOSE,", n);
	}
	if(mask & IN_CLOSE_WRITE)
	{
		strncat(ret, "IN_CLOSE_WRITE,", n);
	}
	if(mask & IN_CREATE)
	{
		strncat(ret, "IN_CREATE,", n);
	}
	if(mask & IN_DELETE)
	{
		strncat(ret, "IN_DELETE,", n);
	}
	if(mask & IN_DELETE_SELF)
	{
		strncat(ret, "IN_DELETE_SELF,", n);
	}
	if(mask & IN_MODIFY)
	{
		strncat(ret, "IN_MODIFY,", n);
	}
	if(mask & IN_MOVE)
	{
		strncat(ret, "IN_MOVE,", n);
	}
	if(mask & IN_MOVE_SELF)
	{
		strncat(ret, "IN_MOVE_SELF,", n);
	}
	if(mask & IN_MOVED_FROM)
	{
		strncat(ret, "IN_MOVED_FROM,", n);
	}
	if(mask & IN_MOVED_TO)
	{
		strncat(ret, "IN_MOVED_TO,", n);
	}

	for(int i = n; i >= 0; --i)
	{
		if(ret[i] == ',')
		{
			ret[i] = 0;
			break;
		}
	}
	ret[1023] = 0;
	return ret;
}

bool run_prog(const char *eventfile, uint32_t eventmask)
{
	pid_t pid = fork();
	if(pid == 0)
	{
		if(path_logfile)
		{
			if(!redirect_stdout(path_logfile))
			{
				return false;
			}
		}

		if(!noenv)
		{
			char envvar[30];
			snprintf(envvar, sizeof(envvar), "ADHOCIFYEVENT=%" PRIu32, eventmask);
			putenv(envvar);
		}

		for(unsigned int i = 0; i < n_script_arguments; i++)
		{
			char *argument = script_arguments[i];
			if(argument != NULL)
			{
				if(STREQ(argument, SCRIPT_PLACE_SPECIFIER) || STREQ(argument, EVENTFILE_PLACEHOLDER))
				{
					script_arguments[i] = eventfile;
				}
				if(STREQ(argument, EVENTSTR_PLACEHOLDER))
				{
					script_arguments[i] = mask_to_names(eventmask);
				}
			}
		}

		execvp(prog, script_arguments);
		logerror("Exec of %s failed: %s\n", prog, strerror(errno));
		int exitcode = (errno == ENOENT) ? 127 : EXIT_FAILURE;
		exit(exitcode);
	}
	if(pid == -1)
	{
		perror("fork");
		return false;
	}

	return true;
}

uint32_t name_to_mask(const char *name)
{
	if(STREQ(name, "IN_CLOSE_WRITE"))
		return IN_CLOSE_WRITE;
	else if(STREQ(name, "IN_OPEN"))
		return IN_OPEN;
	else if(STREQ(name, "IN_MODIFY"))
		return IN_MODIFY;
	else if(STREQ(name, "IN_DELETE"))
		return IN_DELETE;
	else if(STREQ(name, "IN_ATTRIB"))
		return IN_ATTRIB;
	else if(STREQ(name, "IN_CLOSE_NOWRITE"))
		return IN_CLOSE_NOWRITE;
	else if(STREQ(name, "IN_MOVED_FROM"))
		return IN_MOVED_FROM;
	else if(STREQ(name, "IN_MOVED_TO"))
		return IN_MOVED_TO;
	else if(STREQ(name, "IN_CREATE"))
		return IN_CREATE;
	else if(STREQ(name, "IN_DELETE_SELF"))
		return IN_DELETE_SELF;
	else if(STREQ(name, "IN_MOVE_SELF"))
		return IN_MOVE_SELF;
	else if(STREQ(name, "IN_ALL_EVENTS"))
		return IN_ALL_EVENTS;
	else if(STREQ(name, "IN_CLOSE"))
		return IN_CLOSE;
	else if(STREQ(name, "IN_MOVE"))
		return IN_MOVE;
	else
		return 0;
}

void check_forkbomb(const char *path_logfile, const char *path_prog)
{
	char *dir_log = ndirname(path_logfile);
	char *dir_prog = ndirname(path_prog);

	struct watchlistentry *lkp = watchlist_head;
	while(lkp)
	{
		if(lkp->isdir)
		{
			char *dir_lkpPath = lkp->path;
			if(STREQ(dir_lkpPath, dir_log) || STREQ(dir_lkpPath, dir_prog))
			{
				logerror("Don't place your logfiles or command in a directory you are watching for events. Pass -b to "
						 "bypass this check.\n");
				exit(EXIT_FAILURE);
			}
		}

		lkp = lkp->next;
	}

	free(dir_log);
	free(dir_prog);
}

void queue_watches_from_stdin()
{
	char *line = NULL;
	size_t n = 0;
	ssize_t r;
	while((r = getline(&line, &n, stdin)) != -1)
	{
		if(line[r - 1] == '\n')
			line[r - 1] = 0;
		watchqueue_add_path(line);
	}
}

char *get_eventfile_abspath(struct inotify_event *event)
{
	char *wdpath = find_ifd_path(event->wd);
	if(wdpath == NULL)
	{
		return NULL;
	}

	char *result = NULL;
	if((event->len) > 0)
	{
		if(asprintf(&result, "%s/%s", wdpath, event->name) == -1)
		{
			return NULL;
		}
	}
	else
	{
		result = strdup(wdpath);
	}
	return result;
}

void handle_event(struct inotify_event *event)
{
	if(event->mask & mask)
	{
		char *eventfile_abspath = get_eventfile_abspath(event);
		if(eventfile_abspath == NULL)
		{
			logerror("Could not get absolute path for event. Watch descriptor %i\n", event->wd);
			exit(EXIT_FAILURE);
		}

		if(is_ignored(eventfile_abspath))
		{
			free(eventfile_abspath);
			return;
		}
		logwrite("Starting execution of command %s\n", prog);
		bool r = run_prog(eventfile_abspath, event->mask);
		if(!r)
		{
			logerror("Execution of command %s failed\n", prog);
			exit(EXIT_FAILURE);
		}

		fflush(stdout);
		fflush(stderr);

		free(eventfile_abspath);
	}
}

static inline char *get_cwd()
{
	return getcwd(NULL, 0);
}

void print_usage()
{
	printf("adhocify [OPTIONS] command [arguments for command] - Monitor for inotify events and launch commands\n\n");
	printf("--daemon, -d            run as a daemon\n");
	printf("--path, -w              adds the specified path to the watchlist\n");
	printf("--logfile, -o           path to write output of adhocify and stdout/stderr of launched commands to\n");
	printf("--mask, -m              inotify event to watch for (see inotify(7)). Can be specified multiple times to "
		   "watch for several events\n");
	printf("--no-env, -a            if specified, the inotify event which occured won't be passed to the command as an "
		   "environment variable\n");
	printf("--silent, -q            surpress any output created by adhocify itself\n");
	printf("--stdin, -s             Read the paths which must be added to the watchlist from stdin. Each path must be "
		   "in a seperate line\n");
	printf("--no-forkbomb-check, -b Disable fork bomb detection\n");
	printf("--ignore, -i            Shell wildcard pattern (see glob(7)) to ignore events on files for which the "
		   "pattern matches\n");
	printf("--exit-with-child, -e   Exit when the commands exits. You can also specify a return code (e. g. -e=1 to "
		   "exit only on errors)\n");
	printf("\nIf your command should know the file the event occured on, use the {} placeholder when you specify the "
		   "arguments (like xargs)\n");
}

static struct option long_options[] = {{"daemon", no_argument, 0, 'd'},
									   {"logfile", required_argument, 0, 'o'},
									   {"mask", required_argument, 0, 'm'},
									   {"path", required_argument, 0, 'w'},
									   {"no-env", no_argument, 0, 'a'},
									   {"stdin", no_argument, 0, 's'},
									   {"no-forkbomb-check", no_argument, 0, 'b'},
									   {"ignore", required_argument, 0, 'i'},
									   {"silent", no_argument, 0, 'q'},
									   {"help", no_argument, 0, 'h'},
									   {"exit-with-child", optional_argument, 0, 'e'}};

// fills global n_script_arguments and script_arguments var
void fill_script_arguments(size_t n_args, char *args[])
{
	n_script_arguments = n_args + 2; // 2 = argv0 and terminating NULL

	char **arguments = xmalloc(n_script_arguments * sizeof(char *));

	const char *argv0 = memrchr(prog, '/', strlen(prog));
	argv0 = (argv0 == NULL) ? prog : argv0 + 1;
	arguments[0] = argv0;

	const int begin_offset = 1;
	for(unsigned int i = 0; i < n_args; i++)
	{
		char *argument = args[i];
		arguments[i + begin_offset] = strdup(argument);
	}
	arguments[n_args + begin_offset] = NULL;

	script_arguments = arguments;
}

void parse_options(int argc, char **argv)
{
	char *watchpath = NULL;
	int option;
	int option_index;
	uint32_t optmask = 0;
	while((option = getopt_long(argc, argv, "absdo:w:m:l:i:e::", long_options, &option_index)) != -1)
	{
		switch(option)
		{
		case 'd':
			daemonize = true;
			break;
		case 'o':
			path_logfile = optarg;
			break;
		case 'm':
			optmask = name_to_mask(optarg);
			if(optmask == 0)
			{
				logerror("Not supported inotify event: %s\n", optarg);
				exit(EXIT_FAILURE);
			}
			mask |= optmask;
			break;
		case 'w':
			watchpath = optarg;
			watchqueue_add_path(watchpath);
			break;
		case 'a':
			noenv = true;
			break;
		case 's':
			fromstdin = true;
			break;
		case 'b':
			forkbombcheck = false;
			break;
		case 'i':
			add_to_ignore_list(optarg);
			break;
		case 'q':
			silent = true;
			break;
		case 'h':
			print_usage();
			exit(EXIT_SUCCESS);
		case 'e':
			exit_with_child = true;
			if(optarg)
			{
				if(*optarg == '!')
				{
					negate_child_exit_code = true;
					++optarg;
				}
				if(*optarg == '\0')
				{
					logerror("Please specify the exit code\n");
					exit(EXIT_FAILURE);
				}
				awaited_child_exit_code = atoi(optarg);
			}
			break;
		}
	}

	if(optind == argc)
	{
		print_usage();
		logerror("missing command path\n");
		exit(EXIT_FAILURE);
	}

	prog = argv[optind++];

	if(optind <= argc)
	{
		fill_script_arguments(argc - optind, &argv[optind]);
	}
}

void process_options()
{
	if(fromstdin)
	{
		queue_watches_from_stdin();
	}

	if(watchlist_head == NULL)
	{
		watchqueue_add_path(get_cwd());
	}

	if(mask == 0)
	{
		mask |= IN_CLOSE_WRITE;
	}

	if(path_logfile)
	{
		path_logfile = xrealpath(path_logfile, NULL);
	}

	if(forkbombcheck)
	{
		char *path_prog = realpath(prog, NULL);
		if(path_prog != NULL)
		{
			check_forkbomb(path_logfile, path_prog);
		}
		free(path_prog);
	}

	if(daemonize)
	{
		if(daemon(0, 0) == -1)
		{
			perror("daemon");
			exit(EXIT_FAILURE);
		}
	}
}

void start_monitoring(int ifd)
{
	while(1)
	{
		int len;
		int offset = 0;
		char buf[BUF_SIZE];
		len = read(ifd, buf, BUF_SIZE);
		if(len == -1)
		{
			if(errno == EINTR)
				continue;
			perror("read");
			exit(EXIT_FAILURE);
		}

		while(offset < len)
		{

			struct inotify_event *event = (struct inotify_event *)&buf[offset];
			handle_event(event);
			offset += sizeof(struct inotify_event) + event->len;
		}
	}
}

void child_handler(int signum, siginfo_t *info, void *context)
{
	if(signum != SIGCHLD)
	{
		return;
	}

	int status;
	pid_t p = waitpid(-1, &status, WNOHANG);
	if(p == -1)
	{
		logerror("waitpid failed when handling child exit\n");
		exit(EXIT_FAILURE);
	}

	int adhocify_exit_code = 0;
	if(WIFEXITED(status))
	{
		adhocify_exit_code = WEXITSTATUS(status);
		if(adhocify_exit_code == 127)
		{
			logwrite("command not found, exiting\n");
			exit(adhocify_exit_code);
		}
		if(exit_with_child && awaited_child_exit_code > -1)
		{
			bool must_exit = adhocify_exit_code == awaited_child_exit_code;
			if(negate_child_exit_code)
			{
				must_exit = !must_exit;
			}
			if(must_exit)
			{
				logwrite("command exited with specified exit code, exiting too\n");
				exit(adhocify_exit_code);
			}
		}
	}
	if(exit_with_child && WIFSIGNALED(status))
	{
		adhocify_exit_code = 128 + WTERMSIG(status); // copy bash's behaviour
		exit(adhocify_exit_code);
	}
}

void set_signals()
{
	struct sigaction action;
	action.sa_flags = SA_NOCLDSTOP | SA_SIGINFO;
	action.sa_sigaction = &child_handler;
	if(sigaction(SIGCHLD, &action, NULL) == -1)
	{
		logerror("Error when setting up the signal handler\n");
		exit(EXIT_FAILURE);
	}
}

int main(int argc, char **argv)
{
	if(argc < 2)
	{
		print_usage();
		exit(EXIT_FAILURE);
	}

	// signal(SIGCHLD, SIG_IGN);
	set_signals();

	parse_options(argc, argv);
	process_options();

	int ifd = inotify_init();
	if(ifd == -1)
	{
		perror("inotify_init");
		exit(EXIT_FAILURE);
	}
	create_watches(ifd, mask);
	start_monitoring(ifd);
}
