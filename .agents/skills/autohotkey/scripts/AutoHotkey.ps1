<#
.SYNOPSIS
    Runs one or more AutoHotkey v2 scripts via AutoHotkey.exe.

.DESCRIPTION
    Finds AutoHotkey.exe on the system and uses it to execute the specified `.ahk` files.
    The script resolves AutoHotkey.exe from the PATH first, then falls back to a recursive search under $env:ProgramFiles.
    Output from each script is streamed to the console.

.PARAMETER Path
    One or more paths to AutoHotkey script files. Wildcards are supported.
    This parameter accepts pipeline input and property-name binding.

.PARAMETER LiteralPath
    One or more literal paths to AutoHotkey script files. Wildcards are not supported.
    This parameter accepts pipeline input by property name and has the aliases PSPath and LP.

.PARAMETER Switches
    Additional switches to pass to AutoHotkey.exe. These are inserted before the script path.

.PARAMETER ArgumentList
    Additional arguments to pass to Script. These are forwarded after the script path.

.EXAMPLE
    ```powershell
    powershell.exe -NoLogo -NoProfile -File AutoHotkey.ps1 -LiteralPath .\Script.ahk
    ```

    Runs the test suite from a clean PowerShell session.

.EXAMPLE
    ```powershell
    powershell.exe -NoLogo -NoProfile -File AutoHotkey.ps1 -Path .\Tests\*.ahk
    ```

    Runs all AutoHotkey scripts in the specified directory.

.EXAMPLE
    ```powershell
    powershell.exe -NoLogo -NoProfile -File AutoHotkey.ps1 -LiteralPath .\Script.ahk -Switches '/ErrorStdOut', '/NoEnv' -ArgumentList 'foo', 'bar', 'baz'
    ```

    Runs the specified AutoHotkey script with additional switches passed to AutoHotkey.exe before the script path, and additional arguments passed to AutoHotkey.exe after the script path.

.OUTPUTS
    None.
#>
[CmdletBinding(DefaultParameterSetName = 'PathSet', SupportsShouldProcess)]
param (
  [Parameter(Mandatory, ParameterSetName = 'PathSet', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [SupportsWildcards()]
  [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
  [string[]]
  $Path,
  [Alias('PSPath', 'LP')]
  [Parameter(Mandatory, ParameterSetName = 'LiteralPathSet', ValueFromPipelineByPropertyName)]
  [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
  [string[]]
  $LiteralPath,
  [string[]]
  $Switches,
  [string[]]
  [Parameter(ValueFromRemainingArguments)]
  $ArgumentList
)
begin {
  Set-StrictMode -Version Latest

  $ahk = @(where.exe AutoHotkey.exe)[0]
  if (-not $ahk) {
    $ahk = @(where.exe /r $env:ProgramFiles AutoHotkey.exe 2>$null)[0]
  }
  if (-not $ahk) {
    throw 'AutoHotkey.exe not found.'
  }
}
process {
  $items = @(
    switch -Exact -CaseSensitive ($PSCmdlet.ParameterSetName) {
      'PathSet' {
        Get-Item -Path $Path -Force
      }
      'LiteralPathSet' {
        Get-Item -LiteralPath $LiteralPath -Force
      }
    }
  )
  $Switches += '/ErrorStdOut'
  $items | ForEach-Object { & $ahk @Switches $_.FullName @ArgumentList 2>&1 | Out-Default }
}
