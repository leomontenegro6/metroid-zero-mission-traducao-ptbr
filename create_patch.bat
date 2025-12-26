@echo off
del "mzm.ips"
del "mzm.bps"
cd ".\Ferramentas\"

:: Checar se um parâmetro "-bps" é passado como argumento.
:: Se sim, editar o comando para criar um patch BPS ao invés de IPS.
if "%1"=="-bps" (
    .\flips.exe -c --bps "..\orig.gba" "..\mzm.gba" "..\mzm.bps"
) else (
    .\flips.exe -c "..\orig.gba" "..\mzm.gba" "..\mzm.ips"
)