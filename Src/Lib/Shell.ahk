#Requires AutoHotkey v2.0

/**
 * @param {String} command
 * @param {String*} stdout
 * @param {String*} stderr
 * @returns {Integer}
 */
Shell_Exec(command, &stdout?, &stderr?)
{
  exec := ComObject("WScript.Shell").Exec(command)
  stdout := exec.StdOut.ReadAll()
  stderr := exec.StdErr.ReadAll()
  return exec.ExitCode
}
