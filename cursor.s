.macro cursor_left
    setLcd 0, 0, 0, 0, 1    @Envia para os pinos os níveis lógicos especificados pelo manual
    delay timespecnano150   
    setLcd 0, 0, 0, 0, 0    @Envia para os pinos os níveis lógicos especificados pelo manual
    delay timespecnano150
.endm

.macro cursor_right
    setLcd 0, 0, 0, 0, 1    @Envia para os pinos os níveis lógicos especificados pelo manual
    delay timespecnano150   
    setLcd 0, 0, 1, 0, 0    @Envia para os pinos os níveis lógicos especificados pelo manual
    delay timespecnano150
.endm