.macro clear
    setLcd 0, 0, 0, 0, 0  
    delay timespecnano150
    setLcd 0, 0, 0, 0, 1
    delay timespecnano150
.endm