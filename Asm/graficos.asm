; Script que insere edições gráficas na rom.
.gba
.open "mzm.gba", 0x08000000

; Editando fonte dos diálogos
.org 0x08415C60
    .incbin "Graficos/Editados/Fonte dialogos.gba"

; Catalogando ponteiros de gráficos comprimidos e outros dados,
; para que sejam posteriormente atualizados, ao reinserir
; os gráficos na rom.
.org 0x08760AF0
    .dw Continuar
.org 0x08760AF8
    .dw Continuar
.org 0x08760AFC
    .dw Continuar
.org 0x08760B00
    .dw Continuar
.org 0x08760B04
    .dw Continuar
.org 0x08760B08
    .dw Continuar
.org 0x0807C7E0
    .dw DadosDaSamus
.org 0x08760B24
    .dw NomesMenus
.org 0x08760B28
    .dw NomesMenus
.org 0x08760B2C
    .dw NomesMenus
.org 0x08760B30
    .dw NomesMenus
.org 0x08760B34
    .dw NomesMenus
.org 0x08086924
    .dw NovoRecorde
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
.org 0x0807C80C
    .dw TilemapDesconhecido
.org 0x080869F4
    .dw AteProximaMissao
.org 0x0806A6C4
    .dw SelectLigDes
.org 0x08760430
    .dw ApagarDadosBateria
.org 0x08760438
    .dw ApagarDadosBateria
.org 0x08760440
    .dw ApagarDadosBateria
.org 0x08760448
    .dw ApagarDadosBateria
.org 0x08760450
    .dw ApagarDadosBateria
.org 0x08077604
    .dw TelaTitulo

; Inserindo gráficos comprimidos editados no final da rom.
.org 0x08FB5918
Continuar:
    .incbin "Graficos/Editados/Continuar.lz"
    .align

DadosDaSamus:
    .incbin "Graficos/Editados/Dados da Samus.lz"
    .align

NomesMenus:
    .incbin "Graficos/Editados/Nomes menus.lz"
    .align

NovoRecorde:
    .incbin "Graficos/Editados/Novo recorde.lz"
    .align

NomesHabilidades1:
    .incbin "Graficos/Editados/Nomes habilidades 1.lz"
    .align

NomesHabilidades2:
    .incbin "Graficos/Editados/Nomes habilidades 2.lz"
    .align

TilemapDesconhecido:
    .incbin "Graficos/Editados/Tilemap desconhecido.lz"
    .align

AteProximaMissao:
    .incbin "Graficos/Editados/Ate proxima missao.lz"
    .align

SelectLigDes:
    .incbin "Graficos/Editados/Select Lig Des.lz"
    .align

ApagarDadosBateria:
    .incbin "Graficos/Editados/Apagar dados bateria.lz"
    .align

TelaTitulo:
    .incbin "Graficos/Editados/Tela-titulo.lz"
    .align

; Salvando a rom modificada.
.close