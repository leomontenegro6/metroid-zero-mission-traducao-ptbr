:: Arquivo .bat que insere novas edições gráficas na rom, após ter aplicado
:: o patch de gráficos movidos pra área dos 16mb da rom expandida.
:: Feito para seguramente inserir novas edições gráficas sem correr o risco
:: de corromper outros gráficos na rom.
@echo off
echo ==Atualizando imagens comprimidas.==

copy ".\Graficos\Editados\Continuar.gba" ".\Graficos\Editados\Continuar.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Continuar.lz"

copy ".\Graficos\Editados\Dados da Samus.gba" ".\Graficos\Editados\Dados da Samus.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Dados da Samus.lz"

copy ".\Graficos\Editados\Nomes menus.gba" ".\Graficos\Editados\Nomes menus.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Nomes menus.lz"

copy ".\Graficos\Editados\Novo recorde.gba" ".\Graficos\Editados\Novo recorde.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Novo recorde.lz"

copy ".\Graficos\Editados\Nomes habilidades 1.gba" ".\Graficos\Editados\Nomes habilidades 1.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Nomes habilidades 1.lz"

copy ".\Graficos\Editados\Nomes habilidades 2.gba" ".\Graficos\Editados\Nomes habilidades 2.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Nomes habilidades 2.lz"

copy ".\Graficos\Editados\Tilemap desconhecido.gba" ".\Graficos\Editados\Tilemap desconhecido.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Tilemap desconhecido.lz"

copy ".\Graficos\Editados\Ate proxima missao.gba" ".\Graficos\Editados\Ate proxima missao.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Ate proxima missao.lz"

copy ".\Graficos\Editados\Select Lig Des.gba" ".\Graficos\Editados\Select Lig Des.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Select Lig Des.lz"

copy ".\Graficos\Editados\Apagar dados bateria.gba" ".\Graficos\Editados\Apagar dados bateria.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Apagar dados bateria.lz"

copy ".\Graficos\Editados\Tela-titulo.gba" ".\Graficos\Editados\Tela-titulo.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Tela-titulo.lz"

copy ".\Graficos\Editados\Tela-titulo.gba" ".\Graficos\Editados\Tela-titulo.lz"
.\Ferramentas\lzss.exe -evn ".\Graficos\Editados\Tela-titulo.lz"

echo ==Inserindo novos graficos.==
.\Ferramentas\armips-lzss\armips-lzss-v1.exe .\Asm\graficos.asm