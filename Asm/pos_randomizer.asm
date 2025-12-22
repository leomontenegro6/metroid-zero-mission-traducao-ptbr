; Script de consertos pós-randomizador.
;
; Necessário para desfazer determinados assets da tradução
; que podem conflitar com o randomizador, como determinados
; gráficos por exemplo.
.gba
.open "mzm.gba", 0x08000000

; Revertendo gráfico da tela-título
.org 0x08077604
    .stringn 0x00,0x80,0x7F
.org 0x0844F0B4
    .stringn 0x74,0x93,0x7F

; Revertendo textos mostrando o número da seed
.org 0x087609F4
    .stringn 0xE4,0x5C,0x44

.close