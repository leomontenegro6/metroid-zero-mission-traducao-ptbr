.gba
.open "mzm.gba", 0x08000000
.loadtable "./Tabelas/mzm.tbl"

.include "./Asm/Scripts/vanilla/script_1_pointers.asm"
.include "./Asm/Scripts/vanilla/script_2_pointers.asm"

.org 0x08FDD000
.include "./Asm/Scripts/vanilla/script_1.asm"
.include "./Asm/Scripts/vanilla/script_2.asm"

.close