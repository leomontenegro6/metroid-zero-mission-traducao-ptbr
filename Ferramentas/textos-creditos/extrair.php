<?php
/**
 * extrair.php
 *
 * Lê o arquivo binário de créditos do jogo "Creditos (TM).gba", com registros
 * fixos (por padrão 36 bytes), onde o primeiro byte de cada registro é um byte
 * de metadado e os bytes restantes formam um texto ASCII (com padding NULs).
 * Exporta para CSV com duas colunas: metadata (hex) e texto.
 *
 * Uso:
 *   php Ferramentas/extract_texts.php <entrada.bin> <saida.csv> [tamanho_registro]
 *
 * Exemplo:
 *   php Ferramentas/extract_texts.php mensagens.bin mensagens.csv 36
 */

if ($argc < 3) {
    fwrite(STDERR, "Uso: php " . $argv[0] . " <entrada.bin> <saida.csv> [tamanho_registro]\n");
    exit(1);
}

$input = $argv[1];
$output = $argv[2];
$record_size = isset($argv[3]) ? intval($argv[3]) : 36;

if (!is_readable($input)) {
    fwrite(STDERR, "Arquivo de entrada não encontrado ou inacessível: $input\n");
    exit(1);
}

if ($record_size < 2) {
    fwrite(STDERR, "Tamanho de registro inválido. Deve ser >= 2.\n");
    exit(1);
}

$in = fopen($input, 'rb');
if (!$in) {
    fwrite(STDERR, "Falha ao abrir o arquivo de entrada.\n");
    exit(1);
}

$out = fopen($output, 'w');
if (!$out) {
    fwrite(STDERR, "Falha ao abrir o arquivo de saída para escrita: $output\n");
    fclose($in);
    exit(1);
}

// Cabeçalho CSV
fputcsv($out, ['metadata', 'text']);

$index = 0;
while (!feof($in)) {
    $block = fread($in, $record_size);
    if ($block === false || strlen($block) === 0) break;

    // Se o bloco lido for menor que 1 byte, pular
    if (strlen($block) < 1) break;

    $meta_byte = ord($block[0]);
    $meta_hex = sprintf('%02X', $meta_byte);

    $text_raw = substr($block, 1);

    // Remover padding NULs no fim
    $text = rtrim($text_raw, "\x00");

    // Manter apenas caracteres ASCII imprimíveis (0x20-0x7E). Se preferir preservar outros
    // bytes, ajuste esta regex.
    $text = preg_replace('/[^\x20-\x7E]+/', '', $text);

    // Trimar espaços extras
    $text = trim($text);

    fputcsv($out, [$meta_hex, $text]);
    $index++;
}

fclose($in);
fclose($out);

fwrite(STDOUT, "Concluído: $index registros extraídos para $output\n");

exit(0);
