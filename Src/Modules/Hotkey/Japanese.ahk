#Requires AutoHotkey v2.0

; カタカナ/ひらがな/ローマ字 sc070
*sc070:: IME_Set(true)

; 無変換 sc07B
sc07B:: IME_Set(false)
sc07B & Space::sc07B

/**
 * @hotkey   無変換 + [Alphabet]
 * @send     Alt + Shift + [Alphabet]
 */
sc07B & a::!+a
sc07B & b::!+b
sc07B & c::!+c
sc07B & d::!+d
sc07B & e::!+e
sc07B & f::!+f
sc07B & g::!+g
sc07B & h::!+h
sc07B & i::!+i
sc07B & j::!+j
sc07B & k::!+k
sc07B & l::!+l
sc07B & m::!+m
sc07B & n::!+n
sc07B & o::!+o
sc07B & p::!+p
sc07B & q::!+q
sc07B & r::!+r
sc07B & s::!+s
sc07B & t::!+t
sc07B & u::!+u
sc07B & v::!+v
sc07B & w::!+w
sc07B & x::!+x
sc07B & y::!+y
sc07B & z::!+z

sc07B & 1::Numpad1
sc07B & 2::Numpad2
sc07B & 3::Numpad3
sc07B & 4::Numpad4
sc07B & 5::Numpad5
sc07B & 6::Numpad6
sc07B & 7::Numpad7
sc07B & 8::Numpad8
sc07B & 9::Numpad9
sc07B & 0::Numpad0
sc07B & vkBB::NumpadAdd
sc07B & vkBA::NumpadMult
sc07B & vkBD::NumpadSub
sc07B & vkBE::NumpadDot
sc07B & vkBF::NumpadDiv

sc07B & F1::^+F1
sc07B & F2::^+F2
sc07B & F3::^+F3
sc07B & F4::^+F4
sc07B & F5::^+F5
sc07B & F6::^+F6
sc07B & F7::^+F7
sc07B & F8::^+F8
sc07B & F9::^+F9
sc07B & F10::^+F10
sc07B & F11::^+F11
sc07B & F12::^+F12

; https://superuser.com/questions/327866/remote-desktop-sending-ctrl-alt-left-arrow-ctrl-alt-right-arrow-to-the-remote-p
sc07B & Left:: Send("{Blind}^!{Left}")
sc07B & Right:: Send("{Blind}^!{Right}")
sc07B & Up:: Send("{Blind}^!{Up}")
sc07B & Down:: Send("{Blind}^!{Down}")

; 変換 sc079
sc079::sc079

sc079 & h:: Send("<=")
sc079 & j:: Send("<-")
sc079 & k:: Send("->")
sc079 & l:: Send("=>")
sc079 & vkBC:: Send("<=") ; <
sc079 & vkBE:: Send(">=") ; >

#HotIf WinActive("ahk_class Framework::CFrame") ; OneNote
sc079 & vkBA:: Send("!+t") ; :
sc079 & vkBB:: Send("!+d") ; ;
#HotIf WinActive("ahk_class XLMAIN") ; Excel
sc079 & vkBA:: Send("^{vkBA}") ; :
sc079 & vkBB:: Send("^{vkBB}") ; ;
#HotIf WinActive("ahk_group grpExplorer")
sc079 & vkBA:: Paste(Date_ToString("HHmmss")) ; :
sc079 & vkBB:: Paste(Date_ToString("yyyyMMdd")) ; ;
sc079 & vkBF:: Paste(Date_ToString("yyyyMMdd")) ; /
sc079 & vkC0:: Paste(A_Now) ; @
#HotIf !WinActive("ahk_group grpExplorer")
sc079 & vkBA:: Paste(Date_ToString("HH:mm:ss")) ; :
sc079 & vkBB:: Paste(Date_ToString("yyyy-MM-dd")) ; ;
sc079 & vkBF:: Paste(Date_ToString("yyyy/MM/dd")) ; /
sc079 & vkC0:: Paste(Date_ToString("yyyy-MM-ddTHH:mm:ss")) ; @
#HotIf
