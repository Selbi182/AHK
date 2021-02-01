;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Media Hotkeys for Spotify

; Pause Button -> Toggle Media Play-Pause
; Shift + Pause -> Next Song
; Alt + Pause -> Previous Song
Pause::Send {Media_Play_Pause}
+Pause::Send {Media_Next}
!Pause::Send {Media_Prev}

; Stop -> Toggle Shuffle
Media_Stop::
    Spotify_HotkeySend("^s")
    SoundBeep, 1500
    return

; Control + Stop -> Cycle Repeat
^Media_Stop::
    Spotify_HotkeySend("^r")
    SoundBeep, 2000
    return

; VolumeWheel-Down -> Spotify Volume down
volume_down::Spotify_HotkeySend("^{Down}")
^volume_down::Spotify_HotkeySend("^{Down}")

; VolumeWheel-Up -> Spotify Volume up
volume_up::Spotify_HotkeySend("^{Up}")
^volume_up::Spotify_HotkeySend("^{Up}")


; Global variable to cache the Spotify Window ID once it's been found
global cached_spotify_window := Get_Spotify_Id()

; Send a hotkey string to Spotify (regardless of whether it's the active window or not)
Spotify_HotkeySend(hotkeyString) {
    if WinActive("ahk_exe Spotify.exe") {
        Send, %hotkeyString%
    } else {
        DetectHiddenWindows, On
        winId := Get_Spotify_Id()
        ControlFocus, , ahk_id %winId%
        ControlSend, , %hotkeyString%, ahk_id %winId%
        DetectHiddenWindows, Off
    }
    return
}

; Get the ID of the Spotify window (using cache)
Get_Spotify_Id() {
    if (Is_Spotify(cached_spotify_window)) {
        return cached_spotify_window
    }

    WinGet, windows, List, ahk_exe Spotify.exe
    Loop, %windows% {
        winId := windows%A_Index%
        if (Is_Spotify(winId)) {
            cached_spotify_window = %winId%
            return winId
        }
    }
    return 0
}

; Check if the given ID is a Spotify window
Is_Spotify(winId) {
    WinGetClass, class, ahk_id %winId%
    if (class == "Chrome_WidgetWin_0") {
        WinGetTitle, title, ahk_id %winId%
        return (title != "")
    }
    return false
}