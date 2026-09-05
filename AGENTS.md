# Project Guidelines

This repository is a collection of scripts for AutoHotkey v2. Below are the main components and developer guidelines.

## Overview

- `./Bin/` is the directory for built exe files.
- `./Src/Lib/` contains shared functions and utilities. Place reusable code here.
- `./Src/Modules/` contains modules for hotkeys, hotstrings, and key assignments.
- `./Src/Run.ahk` is the resident script. When launched, it runs in the background and provides hotkey and menu features.
- `./Src/Scripts/ContextMenu/*.ahk` are scripts called from Run.ahk's context menu. Place scripts for specific actions here.
- `./Src/Scripts/SendTo/*.ahk` are scripts for the Windows "Send to" menu. These define individual send actions for the context menu.
- `./Src/Tests/` contains AutoHotkey test scripts.

## Workflow

1. `./Src/Lib.ahk` and `./Src/Modules.ahk` are common include files.
   - If you add or remove files in `./Src/`, run `./Src/Include.ahk` to rebuild includes.
1. Run tests from PowerShell with:

   ```powershell
   powershell.exe -NoLogo -NoProfile -File AutoHotkey.ps1 -Path .\Src\Tests\*.Tests.ahk
   ```

   To filter by test case name, pass it as an argument:

   ```powershell
   powershell.exe -NoLogo -NoProfile -File AutoHotkey.ps1 -LiteralPath .\Src\Tests\Array.Tests.ahk -ArgumentList Array_Equal
   ```

## Coding Guidelines

1. Avoid breaking changes unless necessary, and always seek review for such changes.
1. Keep changes minimal and consistent with existing file patterns.
1. When tests exist, update or add tests to cover your changes, and ensure all tests pass before merging.
