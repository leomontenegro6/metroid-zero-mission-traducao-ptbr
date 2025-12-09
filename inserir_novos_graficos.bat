:: Arquivo .bat que insere novas edições gráficas na rom, após ter aplicado
:: o patch de gráficos movidos pra área dos 16mb da rom expandida.
:: Feito para seguramente inserir novas edições gráficas sem correr o risco
:: de corromper outros gráficos na rom.
@echo off
echo ==Atualizando imagens comprimidas.==

set LISTA="Nomes habilidades 1"^
    "Nomes habilidades 2"^
    "Nomes habilidades 3"^
    "Tela-titulo (projectzm)"^
    "Dados da Samus (projectzm)"^
    "Nomes menus (projectzm)"^
    "Nomes menus 2 (projectzm)"

for %%A in (%LISTA%) do (
    echo Processando %%~A...

    copy ".\Graficos\Editados\%%~A.gba" ".\Graficos\Editados\%%~A.lz"
    .\Ferramentas\lzss.exe -evn ".\Graficos\Editados\%%~A.lz"
)

echo ==Inserindo novos graficos.==
.\Ferramentas\armips-lzss\armips-lzss-v1.exe .\Asm\graficos.asm