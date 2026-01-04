:: Arquivo .bat que insere novas edições gráficas na rom, após ter aplicado
:: o patch de gráficos movidos pra área dos 16mb da rom expandida.
:: Feito para seguramente inserir novas edições gráficas sem correr o risco
:: de corromper outros gráficos na rom.
@echo off

REM Inicializa flags
set projectzm=0
set supermetroidrevamp=0

REM Percorre todos os argumentos
for %%A in (%*) do (
    if /I "%%A"=="-projectzm" set projectzm=1
    if /I "%%A"=="-supermetroidrevamp" set supermetroidrevamp=1
)

echo ==Atualizando imagens comprimidas.==

set LISTA="Nomes habilidades 1"^
    "Nomes habilidades 2"^
    "Nomes habilidades 3"^
    "Dados da Samus"^
    "Dados da Samus (TM)"^
    "Nomes menus"^
    "Letras prologo"^
    "Tela-titulo"^
    "Tela-titulo (TM)"^
    "Tela-titulo (projectzm)"^
    "Dados da Samus (projectzm)"^
    "Nomes menus (projectzm)"^
    "Nomes menus 2 (projectzm)"^
    "Dormir status mudar areas"^
    "Nomes localidades (supermetroidrevamp)"^
    "Nomes habilidades 1 (supermetroidrevamp)"^
    "Nomes habilidades 2 (supermetroidrevamp)"^
    "Select Lig Des (supermetroidrevamp)"^
    "Raio Amplo (supermetroidrevamp)"^
    "Raio de Gelo"^
    "Raio Ondular"^
    "Fim de jogo"^
    "Continuar Sim Nao"^
    "Fonte creditos"^
    "Ate proxima missao"

for %%A in (%LISTA%) do (
    echo Processando %%~A...

    copy ".\Graficos\Editados\%%~A.gba" ".\Graficos\Editados\%%~A.lz"
    .\Ferramentas\lzss.exe -evn ".\Graficos\Editados\%%~A.lz"
)

echo ==Reinserindo textos de creditos.==
if !projectzm! equ 1 (
    php .\Ferramentas\textos-creditos\inserir.php ".\Ferramentas\textos-creditos\Creditos (projectzm).csv" ".\Graficos\Editados\Creditos (TM).gba"
) else if !supermetroidrevamp! equ 1 (
    php .\Ferramentas\textos-creditos\inserir.php ".\Ferramentas\textos-creditos\Creditos (supermetroidrevamp).csv" ".\Graficos\Editados\Creditos (TM).gba"
) else (
    php .\Ferramentas\textos-creditos\inserir.php ".\Ferramentas\textos-creditos\Creditos.csv" ".\Graficos\Editados\Creditos (TM).gba"
)

echo ==Inserindo novos graficos.==
.\Ferramentas\armips-lzss\armips-lzss-v1.exe .\Asm\graficos.asm