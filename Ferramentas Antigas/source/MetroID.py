#! /usr/bin/env python
# -*- coding: iso-8859-1 -*-

#MetroID: [GBA]Metroid Zero Mission Dumper Inserter
#Copyright (C) 2007 Trans-Center, Odin

#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 2 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

try: import psyco
except ImportError: pass
import sys
# POG é vida!
# WOP is life!
class MZMDI:
    def __init__(self, filename):
        self.rom_file = open(filename, "r+b")
        self.pointer_addresses = [0x760664, 0x760763, 0x7609A8, 0x760A9F]
        self.invert_three = lambda offset: ((offset << 16)|((offset & 0x00FF00))|(offset >> 16)) & 0xFFFFFF
        self.invert_table = lambda table: dict([[v,k] for k,v in table.items()])
        # Preguiça de codar um módulo para tabelas :)
        # Lazy to code a table library
        self.table = {0x00FE: "<LINE BREAK>\n", 0x00FF: "<END STRING>\n\n",
                      0xC902: "<Se>", 0xCA02: "<le>", 0xCC02: "<ct>",
                      0x0003: "<up>", 0x0203: "<down>", 0x0403: "<left>",
                      0x0603: "<right>", 0x0803: "<A>", 0x0A03: "<B>",
                      0x0C03: "<L>", 0x0E03: "<R>",
                      0x4000: " ", 0x4100: "!", 0x4200: "\"", 0x4300: "#",
                      0x4400: "$", 0x4500: "%", 0x4600: "&", 0x4700: "'",
                      0x4800: "(", 0x4900: ")", 0x4B00: "+", 0x4C00: ",",
                      0x4D00: "-", 0x4E00: ".", 0x4F00: "/", 0x5000: "0",
                      0x5100: "1", 0x5200: "2", 0x5300: "3", 0x5400: "4",
                      0x5500: "5", 0x5600: "6", 0x5700: "7", 0x5800: "8",
                      0x5900: "9", 0x5A00: ":", 0x5B00: ";", 0x5D00: "=",
                      0x1F04: "?", 0x8100: "A", 0x8200: "B", 0x8300: "C",
                      0x8400: "D", 0x8500: "E", 0x8600: "F", 0x8700: "G",
                      0x8800: "H", 0x8900: "I", 0x8A00: "J", 0x8B00: "K",
                      0x8C00: "L", 0x8D00: "M", 0x8E00: "N", 0x8F00: "O",
                      0x9000: "P", 0x9100: "Q", 0x9200: "R", 0x9300: "S",
                      0x9400: "T", 0x9500: "U", 0x9600: "V", 0x9700: "W",
                      0x9800: "X", 0x9900: "Y", 0x9A00: "Z", 0xC100: "a",
                      0xC200: "b", 0xC300: "c", 0xC400: "d", 0xC500: "e",
                      0xC600: "f", 0xC700: "g", 0xC800: "h", 0xC900: "i",
                      0xCA00: "j", 0xCB00: "k", 0xCC00: "l", 0xCD00: "m",
                      0xCE00: "n", 0xCF00: "o", 0xD000: "p", 0xD100: "q",
                      0xD200: "r", 0xD300: "s", 0xD400: "t", 0xD500: "u",
                      0xD600: "v", 0xD700: "w", 0xD800: "x", 0xD900: "y",
                      0xDA00: "z", 0x4601: "À", 0x4701: "Á", 0x4801: "Â",
                      0x4901: "Ã", 0x4A01: "Ç", 0x4B01: "É", 0x4C01: "Ê",
                      0x4D01: "Í", 0x4E01: "Ó", 0x4F01: "Ô", 0x5001: "Õ",
                      0x5101: "Ú", 0x5201: "Ü", 0x5301: "à", 0x5401: "á",
                      0x5501: "â", 0x5601: "ã", 0x5701: "ç", 0x5801: "é",
                      0x5901: "ê", 0x5A01: "í", 0x5B01: "ó", 0x5C01: "ô",
                      0x5D01: "õ", 0x5E01: "ú", 0x5F01: "ü"}
    def __readed_to_int(self, readed):
        """Bytes lidos para inteiros."""
        integer = 0
        for x in readed: integer = (integer << 8) | ord(x)
        return integer
    def __buffering_pointers(self):
        """Armazena ponteiros."""
        pointers_block_1, pointers_block_2 = [], []
        # Armazenando endereços do primeiro bloco
        self.rom_file.seek(self.pointer_addresses[0], 0)
        while self.rom_file.tell() <= self.pointer_addresses[1]:
            pointer = self.invert_three(self.__readed_to_int(self.rom_file.read(3)))
            pointers_block_1.append(pointer)
            self.rom_file.seek(1, 1)
        # Armazenando endereços do segundo bloco
        self.rom_file.seek(self.pointer_addresses[2], 0)
        while self.rom_file.tell() <= self.pointer_addresses[3]:
            pointer = self.invert_three(self.__readed_to_int(self.rom_file.read(3)))
            pointers_block_2.append(pointer)
            self.rom_file.seek(1, 1)
        return pointers_block_1, pointers_block_2
    def extract(self):
        """Extrai o texto da ROM."""
        text_addresses_1, text_addresses_2 = self.__buffering_pointers()
        script_file_1 = open("script_1.txt", "w+b")
        script_file_2 = open("script_2.txt", "w+b")
        # Escreve o Script 1
        for x in range(len(text_addresses_1)):
            self.rom_file.seek(text_addresses_1[x], 0)
            while True:
                bytes = self.__readed_to_int(self.rom_file.read(2))
                if self.table.has_key(bytes) and bytes != 0x00FF: script_file_1.write(self.table[bytes])
                elif bytes == 0x00FF:
                    script_file_1.write(self.table[bytes])
                    break
                else: script_file_1.write("<$" + hex(bytes) + ">")
        # Escreve o Script 2
        for x in range(len(text_addresses_2)):
            self.rom_file.seek(text_addresses_2[x], 0)
            while True:
                bytes = self.__readed_to_int(self.rom_file.read(2))
                if self.table.has_key(bytes) and bytes != 0x00FF: script_file_2.write(self.table[bytes])
                elif bytes == 0x00FF:
                    script_file_2.write(self.table[bytes])
                    break
                else: script_file_2.write("<$" + hex(bytes) + ">")       
        raw_input("\t* Text extration finished.\n\t  Press any key to finish.")
        script_file_1.close()
        script_file_2.close()
    def insert(self, insertion_address = 0x7F7740): # Método Megazord
        """Insere o texto de volta na ROM."""
        self.rom_file.seek(insertion_address, 0)
        new_pointers_1, new_pointers_2 = [], []
        new_pointers_1.append(self.invert_three(self.rom_file.tell()))
        inverted_table = self.invert_table(self.table)
        try:
            script_file_1 = open("script_1.txt", "rb")
            script_file_2 = open("script_2.txt", "rb")
        except IOError:
            raw_input("\t* A script file was not found.\n\t  Press any key to finish.")
            sys.exit()
        # Inserindo o texto do primeiro script de volta na ROM
        while True:
            byte = script_file_1.read(1)
            # Tratamento das tags
            if byte == "<":
                tag_string = ""
                while True:
                    tag_byte = script_file_1.read(1)
                    if tag_byte != ">":
                        tag_string += tag_byte
                        continue
                    elif tag_string[0] == "$":
                        self.rom_file.write(chr(int(tag_string[1:], 16) >> 8))
                        self.rom_file.write(chr(int(tag_string[1:], 16) & 0xFF))
                        break
                    elif tag_string == "LINE BREAK":
                        self.rom_file.write(chr(0x00))
                        self.rom_file.write(chr(0xFE))
                        break
                    elif tag_string == "END STRING":
                        self.rom_file.write(chr(0x00))
                        self.rom_file.write(chr(0xFF))
                        new_pointers_1.append(self.invert_three(self.rom_file.tell()))
                        break
                    elif tag_string == "Se":
                        self.rom_file.write(chr(0xC9))
                        self.rom_file.write(chr(0x02))
                        break
                    elif tag_string == "le":
                        self.rom_file.write(chr(0xCA))
                        self.rom_file.write(chr(0x02))
                        break
                    elif tag_string == "ct":
                        self.rom_file.write(chr(0xCC))
                        self.rom_file.write(chr(0x02))
                        break
                    elif tag_string == "A":
                        self.rom_file.write(chr(0x08))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "B":
                        self.rom_file.write(chr(0x0A))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "L":
                        self.rom_file.write(chr(0x0C))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "R":
                        self.rom_file.write(chr(0x0E))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "up":
                        self.rom_file.write(chr(0x00))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "down":
                        self.rom_file.write(chr(0x02))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "left":
                        self.rom_file.write(chr(0x04))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "right":
                        self.rom_file.write(chr(0x06))
                        self.rom_file.write(chr(0x03))
                        break
                    else:
                        raw_input("\t* Error ocurred with a tag.\n\t  Press any key to finish.")
                        sys.exit()
            # Tratamento dos caracteres
            elif inverted_table.has_key(byte):
                self.rom_file.write(chr(inverted_table[byte] >> 8))
                self.rom_file.write(chr(inverted_table[byte] & 0xFF))
                continue
            if not byte: break
        # Inserindo o texto do segundo script de volta na ROM
        new_pointers_2.append(new_pointers_1.pop())
        while True:
            byte = script_file_2.read(1)
            # Tratamento das tags
            if byte == "<":
                tag_string = ""
                while True:
                    tag_byte = script_file_2.read(1)
                    if tag_byte != ">":
                        tag_string += tag_byte
                        continue
                    elif tag_string[0] == "$":
                        self.rom_file.write(chr(int(tag_string[1:], 16) >> 8))
                        self.rom_file.write(chr(int(tag_string[1:], 16) & 0xFF))
                        break
                    elif tag_string == "LINE BREAK":
                        self.rom_file.write(chr(0x00))
                        self.rom_file.write(chr(0xFE))
                        break
                    elif tag_string == "END STRING":
                        self.rom_file.write(chr(0x00))
                        self.rom_file.write(chr(0xFF))
                        new_pointers_2.append(self.invert_three(self.rom_file.tell()))
                        break
                    elif tag_string == "Se":
                        self.rom_file.write(chr(0xC9))
                        self.rom_file.write(chr(0x02))
                        break
                    elif tag_string == "le":
                        self.rom_file.write(chr(0xCA))
                        self.rom_file.write(chr(0x02))
                        break
                    elif tag_string == "ct":
                        self.rom_file.write(chr(0xCC))
                        self.rom_file.write(chr(0x02))
                        break
                    elif tag_string == "A":
                        self.rom_file.write(chr(0x08))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "B":
                        self.rom_file.write(chr(0x0A))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "L":
                        self.rom_file.write(chr(0x0C))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "R":
                        self.rom_file.write(chr(0x0E))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "up":
                        self.rom_file.write(chr(0x00))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "down":
                        self.rom_file.write(chr(0x02))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "left":
                        self.rom_file.write(chr(0x04))
                        self.rom_file.write(chr(0x03))
                        break
                    elif tag_string == "right":
                        self.rom_file.write(chr(0x06))
                        self.rom_file.write(chr(0x03))
                        break
                    else:
                        raw_input("\t* Error ocurred with a tag.\n\t  Press any key to close.")
                        sys.exit()
            # Tratamento dos caracteres
            elif inverted_table.has_key(byte):
                self.rom_file.write(chr(inverted_table[byte] >> 8))
                self.rom_file.write(chr(inverted_table[byte] & 0xFF))
                continue
            if not byte: break
        new_pointers_2.pop()
        # Atualização dos ponteiros
        self.rom_file.seek(self.pointer_addresses[0])
        for x in range(len(new_pointers_1)):
            self.rom_file.write(chr(new_pointers_1[x] >> 16))
            self.rom_file.write(chr(new_pointers_1[x] >> 8 & 0xFF))
            self.rom_file.write(chr(new_pointers_1[x] & 0xFF))
            self.rom_file.seek(1, 1)
        self.rom_file.seek(self.pointer_addresses[2])
        for y in range(len(new_pointers_2)):
            self.rom_file.write(chr(new_pointers_2[y] >> 16))
            self.rom_file.write(chr(new_pointers_2[y] >> 8 & 0xFF))
            self.rom_file.write(chr(new_pointers_2[y] & 0xFF))
            self.rom_file.seek(1, 1)
        raw_input("\t* Text insertion finished.\n\t  Press any key to finish.")
        script_file_1.close()
        script_file_2.close()

if __name__ == "__main__":
    print """\t+===============================+
        |\tMetroID 0.6\t\t|\n\t|\tTrans-Center, 2007\t|\n\t|\tOdin\t\t\t|
        +===============================+"""
    while True:
        filename = raw_input(">>> File [GBA]Metroid Zero Mission.gba: ")
        if filename == "": filename = "[GBA]Metroid Zero Mission.gba"
        try:
            action = MZMDI(filename)
            while True:
                print ">>> Select task:\n\t1. Extract Text(Via Pointers)\n\t2. Insert Text\n\t3. Exit Program"
                task = raw_input(">>> Your task: ")
                if task.isdigit() == True: task = int(task)
                if task < 1 or task > 3: print "\t* Invalid..."
                elif task == 1:
                    action.extract()
                    break
                elif task == 2:
                    action.insert() 
                    break
                else:
                    sys.exit()
            break
        except IOError:
            print "\t* File %s not found." % filename
            continue
