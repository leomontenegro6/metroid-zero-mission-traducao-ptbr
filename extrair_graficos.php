<?php
$graficos = [
    (object)['nome' => 'Fonte dialogos', 'offset' => '0x415C60', 'tiles' => '32x174', 'codec' => '4bpp'],
];

foreach($graficos as $g){
    $caminho = "Graficos/Originais/{$g->nome}.gba";
    $offset_decimal = hexdec(str_replace('0x', '', $g->offset));
    $tiles = explode('x', $g->tiles);
    $codec = $g->codec ?? '4bpp';
    $tile_size = ($codec == '1bpp') ? (8) : (32);
    $tamanho = $tiles[0] * $tiles[1] * $tile_size;

    shell_exec("dd if=\"orig.gba\" of=\"$caminho\" skip=$offset_decimal count=$tamanho bs=1");
}