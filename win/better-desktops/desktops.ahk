; Caminho completo da DLL (ajuste se estiver em outra pasta)
dll := "VirtualDesktopAccessor.dll"

SwitchDesktopByNumber(n) {
    global dll
    count := DllCall(dll "\GetDesktopCount", "Int")
    if (n > 0 && n <= count) {
        DllCall(dll "\GoToDesktopNumber", "Int", n - 1)
    }
}

; Hotkeys Alt+1 até Alt+4 (pode expandir até 9)
!1::SwitchDesktopByNumber(1)
!2::SwitchDesktopByNumber(2)
!3::SwitchDesktopByNumber(3)
!4::SwitchDesktopByNumber(4)
!5::SwitchDesktopByNumber(5)
!6::SwitchDesktopByNumber(6)
!7::SwitchDesktopByNumber(7)
!8::SwitchDesktopByNumber(8)
!9::SwitchDesktopByNumber(9)\
