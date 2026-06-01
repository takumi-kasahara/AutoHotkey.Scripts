---
name: autohotkey-instructions
description: This file describes the workspace guidelines for editing AutoHotkey scripts.
applyTo: '**/*.ahk'
---

# AutoHotkey Coding Guidelines

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
