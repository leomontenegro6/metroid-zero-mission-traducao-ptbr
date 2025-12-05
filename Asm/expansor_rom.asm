; Script de expansão da rom pra 16mb
.gba
.open "mzm.gba", 0x08000000
.orga filesize("mzm.gba")
.fill 16777216 - filesize("mzm.gba"), 0xff
.close