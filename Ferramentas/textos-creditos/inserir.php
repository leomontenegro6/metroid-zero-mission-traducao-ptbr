<?php
/**
 * inserir.php
 *
 * Lê o arquivo "Creditos.csv" gerado pelo script de extração, onde o CSV tem
 * duas colunas (metadata,text) e gera um arquivo binário com registros fixos
 * (por padrão 36 bytes): 1 byte de metadado seguido pelo texto em ASCII,
 * preenchido com 0x00 até o tamanho do registro. O arquivo final é ajustado
 * ao tamanho alvo (padrão 8640 bytes) adicionando registros nulos
 * se necessário.
 *
 * Uso:
 *   php inserir.php <entrada.csv> <saida.gba> [tamanho_registro] [tamanho_alvo]
 *
 * Exemplo:
 *   php inserir.php Creditos.csv "Creditos (TM).gba" 36 8640
 */

if ($argc < 3) {
    fwrite(STDERR, "Uso: php " . $argv[0] . " <entrada.csv> <saida.gba> [tamanho_registro] [tamanho_alvo]\n");
    exit(1);
}

$input_csv = $argv[1];
$output_file = $argv[2];
$record_size = isset($argv[3]) ? intval($argv[3]) : 36;
$target_size = isset($argv[4]) ? intval($argv[4]) : 8640;

if ($record_size < 2) {
    fwrite(STDERR, "tamanho_registro inválido (deve ser >= 2)\n");
    exit(1);
}

if (!is_readable($input_csv)) {
    fwrite(STDERR, "Arquivo CSV de entrada não encontrado ou inacessível: $input_csv\n");
    exit(1);
}

// Ajusta target_size para ser múltiplo de record_size
$max_records = intdiv($target_size, $record_size);
$effective_target = $max_records * $record_size;
if ($effective_target != $target_size) {
    fwrite(STDOUT, "Aviso: tamanho_alvo ajustado de $target_size para $effective_target (múltiplo de $record_size)\n");
    $target_size = $effective_target;
}

$handle = fopen($input_csv, 'r');
if (!$handle) {
    fwrite(STDERR, "Falha ao abrir CSV: $input_csv\n");
    exit(1);
}

$records = [];
$line_no = 0;
$skipped = 0;
$truncated_texts = 0;

// Detecta se existe cabeçalho (header com as palavras metadata/text)
$first_row = fgetcsv($handle);
if ($first_row === false) {
    fwrite(STDERR, "CSV vazio: $input_csv\n");
    fclose($handle);
    exit(1);
}

$has_header = false;
if (isset($first_row[0]) && preg_match('/metadata/i', $first_row[0])) $has_header = true;
if (isset($first_row[1]) && preg_match('/text|texto/i', $first_row[1])) $has_header = true;

if (!$has_header) {
    // processa a primeira linha como registro
    $row = $first_row;
    $line_no = 1;
    $res = parse_csv_row($row, $record_size);
    if ($res !== null) $records[] = $res; else $skipped++;
} else {
    $line_no = 1; // header line counted
}

while (($row = fgetcsv($handle)) !== false) {
    $line_no++;
    if ($row === null) { $skipped++; continue; }
    $res = parse_csv_row($row, $record_size);
    if ($res !== null) $records[] = $res; else $skipped++;
}

fclose($handle);

$total_from_csv = count($records);
$max_records_available = $max_records;

if ($total_from_csv > $max_records_available) {
    fwrite(STDOUT, "Aviso: CSV possui $total_from_csv registros, mas o tamanho alvo só comporta $max_records_available. Irei truncar extras.\n");
    $records = array_slice($records, 0, $max_records_available);
    $total_from_csv = count($records);
}

$data = "";
foreach ($records as $r) {
    $meta = $r['meta_byte'];
    $text = $r['text_bytes'];
    // Garantir tamanho do texto <= record_size-1
    if (strlen($text) > $record_size - 1) {
        $text = substr($text, 0, $record_size - 1);
        $truncated_texts++;
    }
    $padding_n = ($record_size - 1) - strlen($text);
    $data .= chr($meta) . $text . str_repeat("\x00", $padding_n);
}

$written_records = intdiv(strlen($data), $record_size);

// Preencher até target_size com registros nulos
$padding_records = $max_records_available - $written_records;
if ($padding_records > 0) {
    $data .= str_repeat(str_repeat("\x00", $record_size), $padding_records);
}

// Escrita final
$w = file_put_contents($output_file, $data);
if ($w === false) {
    fwrite(STDERR, "Falha ao escrever arquivo de saída: $output_file\n");
    exit(1);
}

fwrite(STDOUT, "Concluído: escrito $w bytes em '$output_file' ($written_records registros do CSV + $padding_records registros nulos).\n");
if ($skipped) fwrite(STDOUT, "Linhas CSV puladas/invalidas: $skipped\n");
if ($truncated_texts) fwrite(STDOUT, "Textos truncados por tamanho de registro: $truncated_texts\n");

exit(0);

// ------------------------- helpers -------------------------
function parse_csv_row(array $row, int $record_size): ?array {
    // espera pelo menos 2 colunas: metadata, text
    if (!isset($row[0])) return null;
    $meta_raw = trim($row[0]);
    $text_raw = isset($row[1]) ? $row[1] : '';

    // Ignora linhas vazias
    if ($meta_raw === '' && trim($text_raw) === '') return null;

    $meta_byte = parse_meta_byte($meta_raw);
    if ($meta_byte === null) return null;

    // Converte texto UTF-8 para ISO-8859-1 se possível (para manter 1 byte por caractere)
    $text_bytes = convert_to_single_byte($text_raw);

    return ['meta_byte' => $meta_byte, 'text_bytes' => $text_bytes];
}

function parse_meta_byte(string $s): ?int {
    $s = trim($s);
    // Aceita formatos: 02, 0x02, 0X02, 2, 0b10 (binário?)
    if (preg_match('/^0x([0-9A-Fa-f]+)$/', $s, $m)) {
        $v = hexdec($m[1]);
    } elseif (preg_match('/^[0-9A-Fa-f]{1,2}$/', $s) && ctype_xdigit($s)) {
        $v = hexdec($s);
    } elseif (is_numeric($s)) {
        $v = intval($s);
    } else {
        fwrite(STDOUT, "Aviso: metadado inválido '$s' (esperado hex/dec). Linha ignorada.\n");
        return null;
    }
    if ($v < 0 || $v > 255) {
        fwrite(STDOUT, "Aviso: metadado fora do intervalo 0-255: $v. Linha ignorada.\n");
        return null;
    }
    return $v;
}

function convert_to_single_byte(string $s): string {
    // Substituições específicas solicitadas (aplicadas antes da conversão):
    //   ´ => K
    //   ^ => W
    //   ¸ => Y
    //   ~ => ,
    //   ç => &
    $replacements = [
        "´" => "K",
        "^" => "W",
        "¸" => "Y",
        "~" => ",",
        "Ç" => "&",
    ];

    // Aplicar substituições na string original (provavelmente UTF-8 do CSV)
    $s = strtr($s, $replacements);

    // Tentar converter para ISO-8859-1 para garantir 1 byte por caractere no arquivo final.
    if (function_exists('mb_detect_encoding') && mb_detect_encoding($s, 'UTF-8', true) === 'UTF-8') {
        $conv = @iconv('UTF-8', 'ISO-8859-1//TRANSLIT', $s);
        if ($conv !== false) {
            // Também aplicar substituições em versão single-byte (caso algum caractere mude após iconv)
            $single_map = [];
            foreach ($replacements as $k => $v) {
                $k1 = @iconv('UTF-8', 'ISO-8859-1//TRANSLIT', $k);
                if ($k1 !== false && $k1 !== '') $single_map[$k1] = $v;
            }
            if (!empty($single_map)) $conv = strtr($conv, $single_map);
            return $conv;
        }
    }

    return $s;
}
