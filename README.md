# AutoHotkey.Scripts

This is a collection of AutoHotkey v2 scripts designed to run on Windows 11.
AutoHotkey v2 is required. If it is not installed, use the following command:

```bat
winget install --id AutoHotkey.AutoHotkey
```

## Overview

- `./Src/Run.ahk` is a resident script that provides hotkeys and menu features.
- `./Src/Lib/` contains shared libraries and utilities.
- `./Src/Modules/` contains modules that define hotkeys and hotstrings.
- `./Src/Scripts/SendTo/` contains scripts for the Windows "Send to" context menu.

## Usage

1. Run `./Src/Run.ahk` to start the resident script.
1. If needed, build with `./Src/Build.ahk`.
   - Built exe files are placed in `./Bin/`.
   - The exe files work even on environments without AutoHotkey installed.
1. Run `./Src/Install.ahk` to perform installation steps.
1. Run `./Src/Tests.ahk` to execute tests.

## Additional Information

- Place built executables in `./Bin/`.
- `./Src/Include.ahk` is a common include file for the project.
- Individual test scripts are located under `./Src/Tests/`.
- AutoHotkey cannot output results to standard output, so results must be written to a file and then read.
- If a test script fails, a stack trace will be output to `./Log/`.
