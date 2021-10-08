# RedPill Bootwait


## Purpose
This small script-only extension ensures boot process waits until boot device (`/dev/synoboot`) is available before
other processes start launching.

This has a two-fold role:
- avoids failed boots on slower systems (synchronizes against race conditions)
- clearly stops the process when boot device has been misconfigured giving a concise error message in logs

## Installation
This module comes preinstalled/bundled with `redpill-load`. If you're a developer, and you're creating a custom fork you
should use index URL of `https://raw.githubusercontent.com/RedPill-TTG/redpill-boot-wait/master/rpext-index.json`
