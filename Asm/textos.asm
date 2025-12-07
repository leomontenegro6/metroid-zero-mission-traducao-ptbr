.gba
.open "mzm.gba", 0x08000000
.loadtable "./Tabelas/mzm.tbl"

.include "./Asm/Scripts/script_1_pointers.asm"
.include "./Asm/Scripts/script_2_pointers.asm"

.org 0x08FDE2CC
.include "./Asm/Scripts/script_1.asm"
.include "./Asm/Scripts/script_2.asm"

.close