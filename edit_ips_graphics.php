<?php
copy('mzm_graphics.ips', 'mzm_moved_graphics_16mb.ips');
$ips = fopen('mzm_moved_graphics_16mb.ips', 'r+');
$increment = 0x88;

function gotoIpsOffset($ips, $offset) {
    fseek($ips, $offset + 5);
}
function advanceBytes($ips, $bytes_to_advance) {
    fseek($ips, ftell($ips) + $bytes_to_advance);
}
function retreatBytes($ips, $bytes_to_retreat) {
    fseek($ips, ftell($ips) - $bytes_to_retreat);
}
function readByteInHex($ips) {
    $byte = bin2hex(fread($ips, 1));
    retreatBytes($ips, 1);
    return $byte;
}
function incrementByteInHex($ips, $increment) {
    $byte = readByteInHex($ips);
    $byte = dechex(hexdec($byte) + $increment);
    writeByteInHex($ips, $byte);
}
function writeByteInHex($ips, $byte) {
    fwrite($ips, hex2bin($byte));
}

/* Updating pointers to point to the new offset. */
$three_bytes_pointer_offsets = [
    0x000C, 0x0014, 0x001C, 0x0024, 0x002C, 0x0034, 0xE792
];

foreach ($three_bytes_pointer_offsets as $offset) {
    gotoIpsOffset($ips, $offset);
    advanceBytes($ips, 2);
    incrementByteInHex($ips, $increment);
}

// Custom offsets
gotoIpsOffset($ips, 0xE79A);
advanceBytes($ips, 1);
incrementByteInHex($ips, $increment);
for ($i=0; $i<5; $i++) {
    advanceBytes($ips, 3);
    incrementByteInHex($ips, $increment);
}
advanceBytes($ips, 4);
for ($i=0; $i<5; $i++) {
    advanceBytes($ips, 3);
    incrementByteInHex($ips, $increment);
}

gotoIpsOffset($ips, 0xE7CD);
advanceBytes($ips, 2);
incrementByteInHex($ips, $increment);
for ($i=0; $i<4; $i++) {
    advanceBytes($ips, 7);
    incrementByteInHex($ips, $increment);
}

gotoIpsOffset($ips, 0xE7F5);
advanceBytes($ips, 2);
incrementByteInHex($ips, $increment);
advanceBytes($ips, 4);
for ($i=0; $i<5; $i++) {
    advanceBytes($ips, 3);
    incrementByteInHex($ips, $increment);
}

gotoIpsOffset($ips, 0xE815);
advanceBytes($ips, 2);
incrementByteInHex($ips, $increment);
for ($i=0; $i<4; $i++) {
    advanceBytes($ips, 3);
    incrementByteInHex($ips, $increment);
}

/* Moving the destination of the compressed graphics to the new offset */
$graphics_offsets = [
    0x00E82D, 0x00EF3E, 0x00F46E, 0x00F533, 0x00F56D, 0x00F5B4, 0x00F5EE,
    0x00F649, 0x00F662, 0x00F740, 0x00FC50, 0x0100B4, 0x010269, 0x01028C,
    0x0103A4, 0x0103C7, 0x01043E, 0x0104E0, 0x0104E6, 0x0105E2, 0x01068D,
    0x01163E, 0x0119BB, 0x012980, 0x012BF1, 0x013882, 0x0154A7, 0x0158AC,
];

foreach ($graphics_offsets as $offset) {
    gotoIpsOffset($ips, $offset);
    retreatBytes($ips, 5);
    incrementByteInHex($ips, $increment);
}

// save file as another name
fclose($ips);