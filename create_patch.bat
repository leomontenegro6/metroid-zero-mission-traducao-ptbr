@echo off
call build.bat
.\Ferramentas\flips.exe -c "orig.gba" "mzm.gba" "mzm [U] v11.ips"

call build.bat -projectzm
.\Ferramentas\flips.exe -c "orig.gba" "mzm.gba" "mzm_projectzm_ptbr.ips"

call build.bat -supermetroidrevamp
.\Ferramentas\flips.exe -c --bps "orig.gba" "mzm.gba" "mzm_supermetroidrevamp_ptbr.bps"

.\Ferramentas\7z.exe a -tzip "[GBA] Metroid - Zero Mission (U) (1.1).zip"^
    "mzm [U] v11.ips"^
    "LEIAME.txt"^
    "pos_randomizer.ips"^
    "mzm_projectzm_ptbr.ips"^
    "mzm_supermetroidrevamp_ptbr.bps"

del "mzm [U] v11.ips"
del "mzm_projectzm_ptbr.ips"
del "mzm_supermetroidrevamp_ptbr.bps"