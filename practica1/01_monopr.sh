#!/bin/bash 
##############################
# 1)Escribir un script en bash que imprima por salida estándar los números 1 al 10000 utilizando
# una estructura repetitiva for. Al finalizar todas las impresiones, mostrar un mensaje avisando la
# finalización de dicho script. Guardar el script como 01_monopr.sh.
#   a. Modificar el script para que las escrituras por salida estándar se realicen en forma
#   concurrente utilizando el operador &. Guardar el nuevo script como 01_multipr.sh.
#   Describir brevemente lo que ocurre con la secuencia de números escrita por pantalla.
#   b. Modificar el script utilizando la palabra reservada wait, para que las escrituras por
#   pantalla queden reordenadas. Guardar el nuevo script como 01_wait.sh.
#   c. ¿Se podría utilizar sleep para lograr la misma salida que en el punto anterior?
#   Guardar el nuevo script como 01_sleep.sh.
#   d. ¿Qué diferencia hay entre wait y sleep?
##########################################################

for i in {1..5}
do
   echo $i
done