#Requires AutoHotkey v2.0

/**
 * @param {String} command
 * @param {String} stdin
 * @param {VarRef} stdout
 * @param {VarRef} stderr
 * @returns {Integer}
 */
Shell_Exec(command, stdin?, &stdout?, &stderr?)
{
  exec := ComObject("WScript.Shell").Exec(command)
  if (stdin)
  {
    exec.StdIn.Write(stdin)
    exec.StdIn.Close()
  }
  stdout := exec.StdOut.ReadAll()
  stderr := exec.StdErr.ReadAll()
  return exec.ExitCode
}
