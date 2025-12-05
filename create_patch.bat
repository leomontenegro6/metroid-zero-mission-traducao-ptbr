@echo off
del "mzm.ips"
cd ".\Ferramentas\"
.\flips.exe -c "..\orig.gba" "..\mzm.gba" "..\mzm.ips"