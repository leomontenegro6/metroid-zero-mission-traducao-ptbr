; Script de consertos pós-super metroid revamp.
;
; Necessário para desfazer determinados assets da tradução
; que podem conflitar com o hack do Super Metroid Revamp, como determinados
; gráficos por exemplo.
.gba
.open "mzm.gba", 0x08000000

; Revertendo gráfico da tela-título
.org 0x08077604
    .stringn 0x38,0xAE,0x56
.org 0x0844F0B4
    .stringn 0x7C,0xE2,0x44

; Catalogando ponteiros de gráficos comprimidos e outros dados,
; para que sejam posteriormente atualizados, ao reinserir
; os gráficos na rom.
.org 0x0807C7E0
    .dw DadosDaSamus
.org 0x0807C80C
    .dw DadosDaSamusTM
.org 0x08760B24
    .dw NomesMenus1
.org 0x08760B28
    .dw NomesMenus1
.org 0x08760B2C
    .dw NomesMenus1
.org 0x08760B30
    .dw NomesMenus1
.org 0x08760B34
    .dw NomesMenus1

; Inserindo gráficos comprimidos editados no final da rom.
.org 0x08FC90A0
DadosDaSamus:
    .incbin "Graficos/Editados/Dados da Samus.lz"
    .align

DadosDaSamusTM:
    .incbin "Graficos/Editados/Dados da Samus (TM).lz"
    .align

NomesMenus1:
    .incbin "Graficos/Editados/Nomes menus.lz"
    .align

.close