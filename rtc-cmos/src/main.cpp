/*
 * Copyright (c) 2022 Fabio Belavenuto <belavenuto@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */
/*
 * Utility to read DSM power schedule file and configure RTC
 */
#include <iostream>     // std::cout
#include <cstring>      // std::string
#include <fstream>      // std::ifstream, std::ofstream
#include <ctime>        // std::time_t, std::tm
#include <vector>       // std::vector
#include <algorithm>    // std::sort

/* Consts */
const char *dsmFilePath = "/etc/power_sched.conf";
const char *rtcAlarmFilePath = "/sys/class/rtc/rtc0/wakealarm";
const std::string headerOn("[Power On schedule]");

/* Vars */
static std::vector<std::time_t> diffs;

/*****************************************************************************/
void processFile(void) {
    // Open file and check if it exists
    std::ifstream dsmFile(dsmFilePath);
    if (!dsmFile.good()) {
        // Returns because the lack of the file indicates 
        // that there is no configuration
        return;
    }
    std::string line;
    // Read first line
    getline(dsmFile, line);
    // Check if is a Header Power On
    if (line != headerOn) {
        std::cerr << "Header On not found" << std::endl;
        exit(EXIT_FAILURE);
    }
    std::time_t t = std::time(nullptr);   // get time now
    std::tm* now = std::localtime(&t);
    int dayOfWeek = now->tm_wday;

    while (true) {
        // Read the next line
        getline(dsmFile, line);
        try {
            // Convert it to unsigned long long
            int64_t timeOn = std::stoull(line);
            int minute = timeOn & 0xFF;
            int hour = (timeOn >> 8) & 0xFF;
            int daysweek = (timeOn >> 16) & 0xFF;
            int config = (timeOn >> 24) & 0xFF;
            // If enabled
            if (config) {
                std::tm date;
                for (int i = 0; i < 8; i++) {
                    uint8_t mask = 1 << i;
                    if (daysweek & mask) {
                        // Calculate day of week offset
                        int offset = i - dayOfWeek;
                        if (offset < 0) {
                            // If in past, put in future
                            offset += 7;
                        }
                        // Copy struct to calculate difference
                        memcpy(&date, now, sizeof(std::tm));
                        date.tm_hour = hour;
                        date.tm_min  = minute;
                        date.tm_sec  = 0;
                        // Adjust day of week offset
                        std::time_t diff = std::mktime(&date) + (offset * 60 * 60 * 24);
                        // Calculate time difference with offset
                        diff = std::difftime(diff, std::mktime(now));
                        if (diff >= 0) {
                            // If in future, add absolute time to vector
                            diffs.push_back(t + diff);
                        }
                    }
                }
            }
        } catch(std::invalid_argument i) {
            break;
        }
    }
    dsmFile.close();
    if (diffs.size() > 0) {
        // Sort vector to get smallest difference
        std::sort(diffs.begin(), diffs.end());
        std::ofstream almFile(rtcAlarmFilePath);
        if (!almFile.good()) {
            std::cerr << "Error opening rtc alarm file" << std::endl;
            exit(EXIT_FAILURE);
        }
        almFile << 0 << std::endl;
        almFile << diffs[0] << std::endl;
        almFile.close();
    }
}

/*****************************************************************************/
int main(int argc, char **argv) {
    processFile();
}
