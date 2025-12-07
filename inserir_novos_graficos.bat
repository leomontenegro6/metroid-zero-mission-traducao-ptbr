:: Arquivo .bat que insere novas edições gráficas na rom, após ter aplicado
:: o patch de gráficos movidos pra área dos 16mb da rom expandida.
:: Feito para seguramente inserir novas edições gráficas sem correr o risco
:: de corromper outros gráficos na rom.
@echo off
echo ==Atualizando imagens comprimidas.==

copy ".\Graficos\Editados\Nomes habilidades 1.gba" ".\Graficos\Editados\Nomes habilidades 1.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Nomes habilidades 1.lz"

copy ".\Graficos\Editados\Nomes habilidades 2.gba" ".\Graficos\Editados\Nomes habilidades 2.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Nomes habilidades 2.lz"

copy ".\Graficos\Editados\Nomes habilidades 3.gba" ".\Graficos\Editados\Nomes habilidades 3.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Nomes habilidades 3.lz"

echo ==Inserindo novos graficos.==
.\Ferramentas\armips-lzss\armips-lzss-v1.exe .\Asm\graficos.asm