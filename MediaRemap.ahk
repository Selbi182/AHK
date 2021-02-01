;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Selbi's AHK Script Collection ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cheat Sheet

; Volume Down = 174 (0xAE)
; Volume Up =   175 (0xAF)
; Next =        176 (0xB0)
; Prev =        177 (0xB1)
; Stop =        178 (0xB2)
; Play/Pause =  179 (0xB3)

; # Win
; ! Alt
; ^ Ctrl
; + Shift
; & AND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Global Config

#MaxHotkeysPerInterval 150
sendMode Input

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disable Keys

; Disable NumLock and CapsLock (and LeftShift+CapsLock)
; They can now only be changed when pressed with a modifier key
NumLock::return
CapsLock::return
<+CapsLock::return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Extra Text Features

; AltGr + N -> Spanish Enye
<^>!n::ñ
<^>!N::Ñ

; Fix "could'Ve" and similar typos
;~'::send {blind}{lshift up}

; Fix # contraction typos (e.g. could#ve)
; Fix 'Ve contraction typos (e.g. could'Ve)
;::i::I
;;:?*:#t::'t
;;:?*:#s::'s
;:?*:#d::'d
;:?*:#ll::'ll
;:?*:#ve::'ve
;:?*:#re::'re
;:?*:I#m::I'm
;:?*:i#m::I'm
;:?*:i'm::I'm
;:?*:'Ll::'ll
;:?*:'Ve::'ve
;:?*:'Re::'re

; (Disabled because it proved to be even more annoying than without)
; (Perhaps replace with a hotkey to autofix the last word)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Program Start/Restart

; Shift F12 -> Taschenrechner
+F12::run calc.exe

; AltGr+F -> Restart f.lux
<^>!f::
    Process, Close, flux.exe
    run flux.exe
    return

; AltGr+X -> Restart explorer.exe
<^>!x::
    Process, Close, explorer.exe
    run explorer.exe
    return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Volume

; RShift+Del -> Set system volume to 10%
>+Del::
    SoundSet, 0
    AdjustVolume(+10)
    return

; RShift+Home -> Set system volume to 50% (default)
>+Home::
    SoundSet, 0
    AdjustVolume(+50)
    return

; RShift+End -> Set system volume to 100%
>+End::
    SoundSet, 0
    AdjustVolume(+100)
    return

; RShift+PgUp/PgDown -> Adjust system volume in steps of 10%
; (Intended for quick-switching between system audio for headphones and speakers)
>+PgUp::
    AdjustVolume(+10)
    return

>+PgDn::
    AdjustVolume(-10)
    return

AdjustVolume(value) {
    SoundGet, system_volume_tmp
    system_volume_tmp += value
    system_volume_tmp := Round(system_volume_tmp)
    if (system_volume_tmp < 0) {
        system_volume_tmp = 0
    } else if (system_volume_tmp > 100) {
        system_volume_tmp = 100
    }
    SoundSet, system_volume_tmp
    SoundBeep, 100 * (system_volume_tmp / 5)
    return
}

; Mouse5 (north thumb button) -> Reduce volume while held
; (Intended for Overwatch voice communication with speakers, so there is no echo for other players.)
global pushToTalk_volumeControl := false
global system_volume

~>+XButton2::
    if (pushToTalk_volumeControl) {
        SoundBeep, 500
        pushToTalk_volumeControl := false
    } else {
        SoundBeep, 1000
        pushToTalk_volumeControl := true
    }
    return

*~XButton2::
    if (pushToTalk_volumeControl) {
        SoundGet, system_volume
        SoundSet, 10
    }
    return

*~XButton2 UP::
    if (pushToTalk_volumeControl) {
        Send, %system_volume%
        SoundSet, %system_volume%
    }
    return

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
