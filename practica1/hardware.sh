#!/bin/bash
# 4)Escribir un script hardware.sh que genere un archivo texto hardware.txt que contenga:
# a. Nombre del fabricante del sistema.
# b. Versión del procesador que se está utilizando.
# c. Fecha de inicio de la BIOS.
# d. Memoria máxima que el sistema permite.
# e. El tipo de arquitectura utilizada (32 o 64 bits)
# f. Cantidad de CPUs lógicas disponible
# g. El lenguaje instalado para la información de la BIOS
##################################################################




( echo "=========================================================="
echo "a. Nombre del fabricante del sistema:  " 
dmidecode -s system-manufacturer
echo "b. Versión del procesador que se está utilizando:"
 dmidecode -s processor-version
echo "c. Fecha de inicio de la BIOS: " 
 dmidecode -s bios-release-date
echo "d. Memoria máxima que el sistema permite: " 
 dmidecode -t 16 | grep Maximum | awk '{print $2}'
echo "e. El tipo de arquitectura utilizada (32 o 64 bits): " 
uname -m
echo "f. Cantidad de CPUs lógicas disponible:" 
nproc --all
echo "g. El lenguaje instalado para la información de la BIOS: " 
dmidecode -s bios-vendor
echo "=========================================================="
echo "Fin del script") > hardware.txt
