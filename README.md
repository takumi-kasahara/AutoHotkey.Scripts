# AutoHotkey.Scripts

This is a collection of AutoHotkey v2 scripts designed to run on Windows 11.
AutoHotkey v2 is required. If it is not installed, use the following command:

```bat
winget install --id AutoHotkey.AutoHotkey
```

## Overview

- [Sources/Run.ahk](./Sources/Run.ahk) is a resident script that provides hotkeys and menu features.
- [Sources/Lib/](./Sources/Lib) contains shared libraries and utilities.
- [Sources/Modules/](./Sources/Modules) contains modules that define hotkeys and hotstrings.
- [Sources/Scripts/SendTo/](./Sources/Scripts/SendTo) contains scripts for the Windows "Send to" context menu.

## Usage

1. Run [Sources/Run.ahk](./Sources/Run.ahk) to start the resident script.
2. If needed, build with [Sources/Build.ahk](./Sources/Build.ahk).
   - Built exe files are placed in [Bin/](./Bin/).
   - The exe files work even on environments without AutoHotkey installed.
3. Run [Sources/Install.ahk](./Sources/Install.ahk) to perform installation steps.

## Additional Information

- Place built executables in [Bin/](./Bin/).
- Individual test scripts are located under [Tests/](./Tests).
