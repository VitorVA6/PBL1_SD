@Macro que envia um comando de limpar display

.macro clear
    setLcd 0, 0, 0, 0, 0    @Envia para os pinos os níveis lógicos especificados pelo manual
    delay timespecnano150   
    setLcd 0, 0, 0, 0, 1    @Envia para os pinos os níveis lógicos especificados pelo manual
    delay timespecnano150
.endm