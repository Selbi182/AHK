;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Volume Control

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
