:: Arquivo .bat que remonta a rom traduzida.
:: Uso: build.bat [-projectzm] [-supermetroidrevamp] [-randomizer=SEED]
:: Onde:
::   -projectzm: Aplica o patch de do Project ZM (opcional)
::   -supermetroidrevamp: Aplica o patch do Super Metroid Revamp (opcional)
::   -randomizer=SEED: Usa a rom randomizada com a seed SEED (opcional)
::                     (gera erro se o arquivo não existir)
@echo off
setlocal EnableDelayedExpansion
echo ==Gerando rom traduzida.==

REM Inicializa flags
set projectzm=0
set supermetroidrevamp=0
set randomizer=0
set randomizer_seed=0

REM Percorre todos os argumentos
for %%A in (%*) do (
    if /I "%%A"=="-projectzm" set projectzm=1
    if /I "%%A"=="-supermetroidrevamp" set supermetroidrevamp=1

    REM Checa se argumento começa com -randomizer=
    echo %%A | findstr /B /I "\-randomizer" >nul
    if !randomizer! equ 1 (
        set randomizer_seed=%%A
    )
    if !errorlevel! == 0 (
        set randomizer=1
    )
)

REM Evita que patches conflitantes sejam combinados
if !projectzm! equ 1 if !supermetroidrevamp! equ 1 (
    echo ERRO: Não pode usar -projectzm e -supermetroidrevamp juntos.
    exit /b 1
)

del mzm.gba
if !randomizer! equ 1 (
    if not exist mzmrando_!randomizer_seed!.gba (
        echo ERRO: Arquivo mzmrando_!randomizer_seed!.gba nao encontrado.
        exit /b 1
    )

    echo ==Aplicando randomizer.==
    copy mzmrando_!randomizer_seed!.gba mzm.gba
) else (
    copy orig.gba mzm.gba
)

if !projectzm! equ 1 (
    echo ==Aplicando IPS do Project ZM.==
    .\Ferramentas\flips.exe --apply ".\Arquivos Patches\Proj_ZM_083\Proj_ZM_083.ips" .\mzm.gba .\mzm.gba
)

if !supermetroidrevamp! equ 1 (
    echo ==Aplicando IPS do Super Metroid Revamp.==
    .\Ferramentas\flips.exe --apply ".\Arquivos Patches\super_metroid_revamp\668be0bc33f58_Super Metroid - Revamp.bps" .\mzm.gba .\mzm.gba
)

echo ==Expandindo a rom para 16mb.==
.\Ferramentas\armips-lzss\armips-lzss-v1.exe .\Asm\expansor_rom.asm

echo ==Aplicando patches de graficos editados.==
.\Ferramentas\flips.exe --apply .\mzm_graphics.ips .\mzm.gba .\mzm.gba
call inserir_novos_graficos.bat

echo ==Inserindo textos traduzidos.==
.\Ferramentas\armips-lzss\armips-lzss-v1.exe .\Asm\textos.asm

echo Done.