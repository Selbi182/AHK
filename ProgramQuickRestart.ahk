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
