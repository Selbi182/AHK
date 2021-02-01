;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Toggle Transparency

; Shift+Stop -> Toggle transparency for the currently highlighted window
+Media_Stop::
    WinGetTitle, title, A
    App_TransparencyToggle(title, 224, true)
    return

; Toggle Transparency for the given application
App_TransparencyToggle(windowName, transparency, sound) {
    WinGet, Transparent, Transparent, %windowName%
    if (Transparent is integer) {
        WinSet, Transparent, OFF, %windowName%
        if (sound) {
            SoundBeep, 750
        }
    } else {
        WinSet, Transparent, %transparency%, %windowName%
        if (sound) {
            SoundBeep, 1000
        }
    }
    return
}
