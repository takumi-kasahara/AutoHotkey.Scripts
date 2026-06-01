#Requires AutoHotkey v2.0

#MButton:: Send("{Volume_Mute}")
AppsKey & MButton:: Send("{Volume_Mute}")
#HotIf State_IsMouseOver("ahk_class Shell_TrayWnd")
#WheelUp:: Send("{Volume_Down}")
#WheelDown:: Send("{Volume_Up}")
AppsKey & WheelUp:: Send("{Volume_Down}")
AppsKey & WheelDown:: Send("{Volume_Up}")
#HotIf !State_IsMouseOver("ahk_class Shell_TrayWnd")
#WheelUp:: Send("{WheelLeft}")
#WheelDown:: Send("{WheelRight}")
AppsKey & WheelUp:: Send("{WheelLeft}")
AppsKey & WheelDown:: Send("{WheelRight}")
#HotIf
