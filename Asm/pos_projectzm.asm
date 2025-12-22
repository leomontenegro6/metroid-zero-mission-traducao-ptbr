; Script de consertos pós-projectzm.
;
; Necessário para desfazer determinados assets da tradução
; que podem conflitar com o Project ZM, como determinados
; gráficos por exemplo.
.gba
.open "mzm.gba", 0x08000000

; Revertendo tilemap da tela-título
.org 0x0844F0B4
    .stringn 0xE0,0xDB,0x66

; Catalogando ponteiros de gráficos comprimidos e outros dados,
; para que sejam posteriormente atualizados, ao reinserir
; os gráficos na rom.
.org 0x08077604
    .dw TelaTitulo
.org 0x0807C7E0
    .dw DadosDaSamus
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
.org 0x08077D80
    .dw NomesMenus2
.org 0x0807C7F0
    .dw NomesMenus2

; Inserindo gráficos comprimidos editados no final da rom.
.org 0x08FC90A0
TelaTitulo:
    .incbin "Graficos/Editados/Tela-titulo (projectzm).lz"
    .align

DadosDaSamus:
    .incbin "Graficos/Editados/Dados da Samus (projectzm).lz"
    .align

NomesMenus1:
    .incbin "Graficos/Editados/Nomes menus (projectzm).lz"
    .align

NomesMenus2:
    .incbin "Graficos/Editados/Nomes menus 2 (projectzm).lz"
    .align

.close