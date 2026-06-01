#Requires AutoHotkey v2.0

AppsKey::AppsKey
/**
 * Press Copilot Key
 * @hotkey  AppsKey + Enter
 * @send    Win + Shift + F23
 */
AppsKey & Enter::#+F23
/**
 * Open Clipboard History
 * @hotkey  AppsKey + Insert
 * @send    Win + V
 */
AppsKey & Insert::#v
/**
 * @hotkey  AppsKey + Delete
 * @send    Win + Tab
 */
AppsKey & Delete::#Tab
/**
 * @hotkey  AppsKey + Home
 * @send    Win + Ctrl + Left
 */
AppsKey & Home::#^Left
/**
 * @hotkey  AppsKey + End
 * @send    Win + Ctrl + Right
 */
AppsKey & End::#^Right

AppsKey & PgUp::ShiftAltTab
AppsKey & PgDn::AltTab

AppsKey & Left::Media_Prev
AppsKey & Right::Media_Next
AppsKey & Space::Media_Play_Pause
AppsKey & Up::Volume_Up
AppsKey & Down::Volume_Down

; #region Open Special Folder
; https://learn.microsoft.com/en-us/windows/apps/develop/launch/launch-settings
; https://learn.microsoft.com/en-us/windows/win32/shell/controlpanel-canonical-names
; https://learn.microsoft.com/en-us/windows/win32/shell/executing-control-panel-items
; https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid
AppsKey & a:: Open_Choice("ms-settings:appsfeatures", { Shift: "ms-settings:defaultapps" })
AppsKey & b:: Open_Choice("shell:RecycleBinFolder")
AppsKey & c:: Open_Choice("control.exe /name Microsoft.CredentialManager")
AppsKey & d:: Open_Choice("ms-settings:display")
AppsKey & e:: Open_Choice("control.exe /name Microsoft.FolderOptions")
AppsKey & i:: Open_Choice("ms-settings:regionlanguage-jpnime", { Shift: "control.exe input.dll,,{C07337D3-DB2C-4D0B-9A93-B722A6C106E2}" })
AppsKey & k:: Open_Choice("ms-settings:typing", { Shift: "control.exe /name Microsoft.Keyboard" })
AppsKey & m:: Open_Choice("ms-settings:mousetouchpad", { Shift: "control.exe /name Microsoft.Mouse" })
AppsKey & n:: Open_Choice("ms-settings:network-status", { Shift: "control.exe /name Microsoft.NetworkAndSharingCenter" })
AppsKey & p:: Open_Choice("ms-settings:printers", { Shift: "mspaint.exe" })
AppsKey & s:: Open_Choice("ms-settings:sound", { Shift: "control.exe /name Microsoft.Sound" })
AppsKey & t:: Open_Choice("shell:SendTo")
AppsKey & u:: Open_Choice("shell:Startup")
AppsKey & w:: Open_Choice("ms-settings:windowsupdate")
AppsKey & x:: Open_Choice("shell:ProgramFilesX64", { Shift: "shell:ProgramFilesX86" })
AppsKey & z:: Open_Choice("ms-settings:storagesense", { Shift: "ms-settings:disksandvolumes" })

AppsKey & vkBA:: Open_Choice("ms-settings:regionlanguage", { Shift: "control.exe /name Microsoft.RegionAndLanguage" }) ; :
AppsKey & vkBB:: Open_Choice("ms-settings:dateandtime", { Shift: "control.exe /name Microsoft.DateAndTime" }) ; ;
AppsKey & vkBC:: Open_Choice("control.exe") ; ,
AppsKey & vkBE:: Open_Choice("shell:Profile") ; .
AppsKey & vkBF:: Open_Choice("shell:Desktop") ; /
AppsKey & vkC0:: Open_Choice("shell:Personal") ; @
AppsKey & vkE2:: Open_Choice("shell:Downloads") ; \

AppsKey & BackSpace:: Open_Choice("ms-settings:bluetooth")
AppsKey & PrintScreen:: Open_Choice("shell:Screenshots", { Shift: "shell:Captures" })
; #endregion
/**
 * Force Reboot
 * @hotkey  AppsKey + ScrollLock
 */
AppsKey & ScrollLock:: MsgBox(A_ComputerName "\" A_UserName " will be rebooted.", , 0x131) == "OK" ? Shutdown(0x2 ^ 0x4) : 0
#HotIf State_IsRemote()
/**
 * Force Logoff
 * @hotkey  AppsKey + Pause
 */
AppsKey & Pause:: MsgBox(A_ComputerName "\" A_UserName " will be logged off.", , 0x131) == "OK" ? Shutdown(0x0 ^ 0x4) : 0
#HotIf !State_IsRemote()
/**
 * Force Shutdown
 * @hotkey  AppsKey + Pause
 */
AppsKey & Pause:: MsgBox(A_ComputerName "\" A_UserName " will be shutdown.", , 0x131) == "OK" ? Shutdown(0x1 ^ 0x4) : 0
#HotIf
