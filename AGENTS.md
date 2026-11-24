# Project Guidelines

This repository is a collection of scripts for AutoHotkey v2. Below are the main components and developer guidelines.

## Overview

- [Bin/](./Bin/) is the directory for built exe files.
- [Sources/Lib/](./Sources/Lib) contains shared functions and utilities. Place reusable code here.
- [Sources/Modules/](./Sources/Modules) contains modules for hotkeys, hotstrings, and key assignments.
- [Sources/Run.ahk](./Sources/Run.ahk) is the resident script. When launched, it runs in the background and provides hotkey and menu features.
- [Sources/Scripts/ContextMenu/*.ahk](./Sources/Scripts/ContextMenu) are scripts called from [Sources/Run.ahk](./Sources/Run.ahk)'s context menu. Place scripts for specific actions here.
- [Sources/Scripts/SendTo/*.ahk](./Sources/Scripts/SendTo) are scripts for the Windows "Send to" menu. These define individual send actions for the context menu.
- [Tests/](./Tests) contains AutoHotkey test scripts.

## Workflow

1. [Lib.ahk](./Sources/Lib.ahk) and [Modules.ahk](./Sources/Modules.ahk) are common include files.
   - If you add or remove files in [Sources/](./Sources), run [Preproc.ahk](./Sources/Preproc.ahk) to rebuild includes.
2. Run tests from [run.cmd](./.agents/skills/autohotkey/scripts/run.cmd):

```bat
".agents\skills\autohotkey\scripts\run.cmd" -Path "Script.ahk"
```

```powershell
& '.\.agents\skills\autohotkey\scripts\run.cmd' -Path '.\Script.ahk'
```

## Coding Guidelines

1. Avoid breaking changes unless necessary, and always seek review for such changes.
2. Keep changes minimal and consistent with existing file patterns.
3. When tests exist, update or add tests to cover your changes, and ensure all tests pass before merging.
