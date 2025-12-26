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

; Editando OAMs do menu de inventário, para "descortar" os nomes
; "Traje" e "Diversos", ao apertar o botão R.
.org 0x083FD4AE
    .stringn 0xB2,0xB1
.org 0x083FD4BF
    .stringn 0x00,0x40,0x40,0x72,0xB3,0x00,0x40,0x20,0x80,0xB4,0xB1

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
;.org 0x08760174
;    .dw DormirStatusMudarAreas
.org 0x0876017C
    .dw DormirStatusMudarAreas
.org 0x08760180
    .dw DormirStatusMudarAreas
.org 0x08760184
    .dw DormirStatusMudarAreas
.org 0x08760188
    .dw DormirStatusMudarAreas
.org 0x0876018C
    .dw DormirStatusMudarAreas
.org 0x08760104
    .dw NomesLocalidades
.org 0x0876010C
    .dw NomesLocalidades
.org 0x08760110
    .dw NomesLocalidades
.org 0x08760114
    .dw NomesLocalidades
.org 0x08760118
    .dw NomesLocalidades
.org 0x0876011C
    .dw NomesLocalidades
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
.org 0x0806A6C4
    .dw SelectLigDes
.org 0x0875EC40
    .dw RaioAmplo
.org 0x0875EC44
    .dw RaioAmplo
.org 0x0875EC48
    .dw RaioDeGelo
.org 0x0875EC4C
    .dw RaioDeGelo
.org 0x0875EC50
    .dw RaioOndular
.org 0x0875EC54
    .dw RaioOndular
.org 0x08077D78
    .dw FimDeJogo
.org 0x08760AF0
    .dw ContinuarSimNao
.org 0x08760AF8
    .dw ContinuarSimNao
.org 0x08760AFC
    .dw ContinuarSimNao
.org 0x08760B00
    .dw ContinuarSimNao
.org 0x08760B04
    .dw ContinuarSimNao
.org 0x08760B08
    .dw ContinuarSimNao

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

DormirStatusMudarAreas:
    .incbin "Graficos/Editados/Dormir status mudar areas.lz"
    .align

NomesLocalidades:
    .incbin "Graficos/Editados/Nomes localidades (supermetroidrevamp).lz"
    .align

NomesHabilidades1:
    .incbin "Graficos/Editados/Nomes habilidades 1 (supermetroidrevamp).lz"
    .align

NomesHabilidades2:
    .incbin "Graficos/Editados/Nomes habilidades 2 (supermetroidrevamp).lz"
    .align

NomesHabilidades3:
    .incbin "Graficos/Editados/Nomes habilidades 3.lz"
    .align

SelectLigDes:
    .incbin "Graficos/Editados/Select Lig Des (supermetroidrevamp).lz"
    .align

RaioAmplo:
    .incbin "Graficos/Editados/Raio Amplo (supermetroidrevamp).lz"
    .align

RaioDeGelo:
    .incbin "Graficos/Editados/Raio de Gelo.lz"
    .align

RaioOndular:
    .incbin "Graficos/Editados/Raio Ondular.lz"
    .align

FimDeJogo:
    .incbin "Graficos/Editados/Fim de jogo.lz"
    .align

ContinuarSimNao:
    .incbin "Graficos/Editados/Continuar Sim Nao.lz"
    .align

.close