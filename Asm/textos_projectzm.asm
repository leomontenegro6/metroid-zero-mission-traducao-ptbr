.gba
.open "mzm.gba", 0x08000000
.loadtable "./Tabelas/mzm_fonte_fina.tbl"

.include "./Asm/Scripts/projectzm/script_1_pointers.asm"
.include "./Asm/Scripts/projectzm/script_2_pointers.asm"

.org 0x08FDD000
.include "./Asm/Scripts/projectzm/script_1.asm"
.include "./Asm/Scripts/projectzm/script_2.asm"

.close