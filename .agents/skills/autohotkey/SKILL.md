---
name: autohotkey
description: "AutoHotkey v2 coding guidelines (Windows 11). Use when: writing or editing *.ahk, variable/function naming, Format() usage, regex with ~=, DllCall/COM integration, Try-Catch-Finally error handling, WINAPI type mapping, running scripts via AutoHotkey.ps1, FileAppend stdout/stderr output."
argument-hint: "Describe the AutoHotkey v2 script or function you are writing or editing."
user-invocable: true
---

# AutoHotkey v2 Coding Guidelines

Guidelines for writing and editing AutoHotkey v2 scripts in this repository.

## When to Use This Skill

- Writing or editing any `*.ahk` file
- Naming variables, constants, or functions
- Formatting strings with `Format()`
- Writing regular expression checks
- Calling WINAPI via `DllCall` or using COM objects
- Adding error handling for file operations, inputs, or system calls
- Running AutoHotkey scripts via `AutoHotkey.ps1`
- Outputting to stdout or stderr using `FileAppend`

## Running Scripts

- Use `AutoHotkey.ps1` to run AutoHotkey v2 scripts from PowerShell.
  - [AutoHotkey.ps1](./scripts/AutoHotkey.ps1)
- Find the script at `.agents/skills/autohotkey/scripts/AutoHotkey.ps1`.
- Run a single script:

  ```powershell
  powershell.exe -NoLogo -NoProfile -File .agents\skills\autohotkey\scripts\AutoHotkey.ps1 -LiteralPath .\Src\Run.ahk
  ```

- Run multiple scripts with wildcards:

  ```powershell
  powershell.exe -NoLogo -NoProfile -File .agents\skills\autohotkey\scripts\AutoHotkey.ps1 -Path .\Src\Tests\*.Tests.ahk
  ```

- Pipe files to the script:

  ```powershell
  Get-ChildItem .\Src\Scripts\ContextMenu\*.ahk | .agents\skills\autohotkey\scripts\AutoHotkey.ps1
  ```

## Output to Console

- Use `FileAppend()` to write to stdout or stderr.
  - [FileAppend](https://www.autohotkey.com/docs/v2/lib/FileAppend.htm)
- Write to stdout:

  ```autohotkey
  FileAppend("Hello stdout", "*")
  ```

- Write to stderr:

  ```autohotkey
  FileAppend("Hello stderr", "**")
  ```

- This is useful for debugging and error reporting in scripts run via `AutoHotkey.ps1`.

## Compatibility

1. Target environment is Windows 11.
2. AutoHotkey version is v2.

## Coding Style

**Priority**: Rules marked as mandatory must always be followed. All other rules are strong recommendations.

- **Mandatory**: Variable Naming, Function Naming
- **Recommendation**: Formatting, String Formatting, Regular Expressions, System Integration

### Formatting

- Omit curly braces `{}` for single-line `if` statements and loops.
  - [Format](https://www.autohotkey.com/docs/v2/Format.htm)

### Variable Naming

- Use `lowerCamelCase` for variable names.
  - Avoid reassignment unless it significantly improves performance or is required for compatibility with external libraries.
- Use `UPPER_SNAKE_CASE` for constants.

### Function Naming

- Use the `FileName_FunctionName` format for function names.

### String Formatting

- Use `Format()` only when specifying format specifiers.
  - OK: `value " cm"`
  - OK: `Format("{:0.2f} cm", value)`
  - NG: `Format("{} cm", value)`

### Escape Sequences

AutoHotkey v2 uses the backtick character (`` ` ``) as its escape character inside expressions. Outside expressions (in literal strings), use ` `` ` (double backtick) for a literal backtick.

Common [Escape Sequences](https://www.autohotkey.com/docs/v2/misc/EscapeChar.htm):

| Sequence | Meaning                                   |
| -------- | ----------------------------------------- |
| ` `` `   | Literal backtick                          |
| `` `, `` | Literal comma                             |
| `` `; `` | Literal semicolon                         |
| `` `% `` | Literal percent                           |
| `` `# `` | Literal hash                              |
| `` `: `` | Literal colon                             |
| `` `" `` | Literal double-quote                      |
| `` `n `` | Newline (` Chr(10)`)                      |
| `` `r `` | Carriage return (` Chr(13)`)              |
| `` `t `` | Tab (` Chr(9)`)                           |
| `` `b `` | Backspace (` Chr(8)`)                     |
| `` `v `` | Vertical tab (` Chr(11)`)                 |
| `` `a `` | Alert/bell (` Chr(7)`)                    |
| `` `f `` | Form feed (` Chr(12)`)                    |
| `` `s `` | Literal space (useful in expressions)     |
| `` `" `` | Literal Double-quote (when Double-quoted) |
| `` `' `` | Literal single-quote (when Single-quoted) |

### `Chr()` Function

[Chr()](https://www.autohotkey.com/docs/v2/lib/Chr.htm) returns the character for a given Unicode code point. Use this when a character cannot be safely written as a literal in a string.

```autohotkey
tick      := Chr(96)  ; backtick
quote     := Chr(34)  ; double-quote
backslash := Chr(92)  ; backslash
```

**When to use `Chr()` instead of escape sequences:**

1. When the character cannot appear safely in a string literal (e.g., backtick inside a string that already contains backticks).
2. When building regex patterns that will be used with `~=` or `RegExMatch()`.
3. When passing special characters to external functions (COM, DllCall) where escape handling differs.

### Regular Expressions

- Use `~=` for regular expression checks.
  - Use `RegExMatch()` only when optional arguments are needed.
  - [RegEx](https://www.autohotkey.com/docs/v2/misc/RegEx-QuickRef.htm)

### System Integration

- Use `DllCall` and COM when no built-in AutoHotkey functions or libraries can achieve the desired functionality.
  - [DllCall](https://www.autohotkey.com/docs/v2/lib/DllCall.htm)
  - [Windows Data Types](https://learn.microsoft.com/en-us/windows/win32/winprog/windows-data-types)

| WINAPI      | typedef                                           | type      |
| ----------- | ------------------------------------------------- | --------- |
| `BOOL`      | `typedef int BOOL, *PBOOL, *LPBOOL;`              | `Int`     |
| `DWORD_PTR` | `typedef ULONG_PTR DWORD_PTR;`                    | `UInt`    |
| `DWORD`     | `typedef unsigned long DWORD, *PDWORD, *LPDWORD;` | `UInt`    |
| `HANDLE`    | `typedef PVOID HANDLE;`                           | `Ptr`     |
| `HGLOBAL`   | `typedef HANDLE HGLOBAL;`                         | `Ptr`     |
| `HRESULT`   | `typedef LONG HRESULT;`                           | `HRESULT` |
| `HWND`      | `typedef HANDLE HWND;`                            | `Ptr`     |
| `int`       |                                                   | `Int`     |
| `INT`       | `typedef int INT, *LPINT;`                        | `Int`     |
| `INT64`     | `typedef signed __int64 INT64;`                   | `Int64`   |
| `long`      |                                                   | `Int`     |
| `LONG`      | `typedef long LONG, *PLONG, *LPLONG;`             | `Int`     |
| `LPCWSTR`   | `typedef const wchar_t *LPCWSTR;`                 | `WStr`    |
| `LPVOID`    | `typedef void *LPVOID;`                           | `Ptr`     |
| `LPWSTR`    | `typedef wchar_t *LPWSTR, *PWSTR;`                | `WStr`    |
| `PCWSTR`    | `typedef const WCHAR *PCWSTR;`                    | `WStr`    |
| `PWSTR`     | `typedef wchar_t *LPWSTR, *PWSTR;`                | `WStr`    |
| `WCHAR`     | `typedef wchar_t WCHAR, *PWCHAR;`                 | `WStr`    |

## Error Handling

- Ensure all scripts include error handling for file operations, invalid inputs, and system calls.
- Use `Try`-`Catch`-`Finally` blocks where applicable.
  - [Try](https://www.autohotkey.com/docs/v2/lib/Try.htm)
  - [Catch](https://www.autohotkey.com/docs/v2/lib/Catch.htm)
  - [Finally](https://www.autohotkey.com/docs/v2/lib/Finally.htm)

## References

- [AutoHotkey Quick Reference](https://www.autohotkey.com/docs/v2/)
