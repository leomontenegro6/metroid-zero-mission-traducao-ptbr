; Script que insere novas edições gráficas na rom, após ter aplicado
; o patch de gráficos movidos pra área dos 16mb/32mb da rom expandida.
.gba
.open "mzm.gba", 0x08000000

; Editando fonte dos diálogos
.org 0x08415C60
    .incbin "Graficos/Editados/Fonte dialogos.gba"
.org 0x0840D7B0
    .incbin "Graficos/Editados/Fonte dialogos (VWF).gba"

; Catalogando ponteiros de gráficos comprimidos e outros dados,
; para que sejam posteriormente atualizados, ao reinserir
; os gráficos na rom.
.org 0x08080348
    .dw LetrasPrologo
.org 0x08080E40
    .dw LetrasPrologo
.org 0x08082E24
    .dw LetrasPrologo
.org 0x08077604
    .dw TelaTitulo
.org 0x0844F0B4
    .dw TelaTituloTM
.org 0x08760158
    .dw NomesHabilidades1
.org 0x08760160
    .dw NomesHabilidades2
.org 0x08760164
    .dw NomesHabilidades2
.org 0x08760168
    .dw NomesHabilidades2
.org 0x0876016C
    .dw NomesHabilidades2
.org 0x08760170
    .dw NomesHabilidades2
.org 0x0876013C
    .dw NomesHabilidades3

; Inserindo gráficos comprimidos editados no final da rom.
.org 0x08FE90A0
LetrasPrologo:
    .incbin "Graficos/Editados/Letras prologo.lz"
    .align

TelaTitulo:
    .incbin "Graficos/Editados/Tela-titulo.lz"
    .align

TelaTituloTM:
    .incbin "Graficos/Editados/Tela-titulo (TM).lz"
    .align

NomesHabilidades1:
    .incbin "Graficos/Editados/Nomes habilidades 1.lz"
    .align

NomesHabilidades2:
    .incbin "Graficos/Editados/Nomes habilidades 2.lz"
    .align

NomesHabilidades3:
    .incbin "Graficos/Editados/Nomes habilidades 3.lz"
    .align

; Salvando a rom modificada.
.close