# Créditos do jogo

Os créditos do jogo tão situados no 0x54C10C, e vão até o offset 0x54E2CC, totalizando cerca de 8640 bytes.

Eles estão em um formato que lembra muito tilemaps de 1 byte por tile, porém possuem algumas particularidades. O arquivo tá dividido em várias sequências de 36 bytes cada, onde cada sequência equivale a uma linha de créditos a ser impressa na tela. Ao todo são 240 linhas.

O primeiro byte de cada linha contém metadados: um byte que diz se vai usar a fonte pequena (0x00), a fonte grande (0x02), se não vai mostrar nada (05), ou se será uma região reservada para mostrar gráficos fora das fontes (com valores de 0x0A até 0x0D).

Do segundo byte até o final, ela contém textos em padrão ASCII. Apesar da linha teoricamente caber até 35 letras, ingame ela parece aceitar no máximo 30 letras. E cada letra possui dimensões de 8x8 (fonte pequena) ou 8x16 (fonte grande). Ultrapassar esse limite pode causar bugs menores na rom.

Já quanto à fonte dos créditos em si, ela tá comprimida em LZSS 0x10. O offset do seu ponteiro absoluto está em 0x0855E8, o que por sua vez aponta para o offset 0x54E2F0, que é onde os dados comprimidos em si estão. Para adicionar caracteres acentuados a mais, pode ser preciso editar essa fonte.

# Ferramenta de edição

Dadas as especificações acima, foi criada uma ferramenta em PHP chamada "textos-creditos", capaz de extrair os textos dos créditos pra CSV, e inserir eles de volta. Isso facilitará um bocado o remanejamento de blocos de texto, pra arranjar espaço para adicionar mais linhas de crédito sem precisar expandir o arquivo em si. A ferramenta foi criada com o ChatGPT, e você encontra seus arquivos em "Ferramentas/textos-creditos".

# Acentos necessários pros créditos PT-BR

Apenas a fonte pequena de 8x8 precisa ser acentuada, pois a grande de 8x16 só contém nomes em japonês ou inglês que não requerem acentos. Inicialmente, eu havia acentuado a letra nos limites de 8x8, porém dessa vez será possível colocar os acentos acima ou abaixo das letras, como se a fonte pequena ocupasse 8x16.

Para isso, os seguintes acentos avulsos precisarão ser adicionados na fonte:

´~^¸

Eu os editei, e fiz as seguintes trocas:

K=´
W=^
Y=¸
,=~
&=Ç

A ferramenta "textos-creditos" também contempla essas trocas no processo de construção do arquivo binário. Os valores estão na função PHP "convert_to_single_byte", e podem ser customizadas à vontade se necessário.