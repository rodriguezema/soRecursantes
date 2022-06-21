#!/bin/bash

#####################################################################################################
# Ejercicio 1
# Parte 1:
# Escribir un script en bash llamado bloip.sh que cada minuto verifique las IP a las que está
# conectado el equipo y las compare con una lista en el archivo /control/list_IPProhibited.txt
# Si es así:
# - Corte la conexión.
# - Mande un mail al root informando el usuario, la hora, la IP y el dominio.
# - Despliegue un cartel en pantalla informando al usuario que dicha conexión está prohibida.
# Parte 2:
# Escriba un script de instalación que se ejecute solamente por el root y que:
# Cree el directorio /control (propietario root)
# Cree dentro del directorio root el archivo list_IPProhibited.txt vacío. Agregue a todos los archivos 
#.profile existentes la ejecucion del script bloip.sh
# Agregue al .profile modelo el script para que toda alta nueva de usuarios tenga el script incorporado
# Parte 3:
# Escriba un script que se ejecute solamente por el root y que:
# Abra un menú:
# - Opción 1: Pregunta por una IP y la agrega al archivo list_IPProhibited.txt con su dominio.
# - Opción 2: Pregunta por un dominio, busca la IP y la agrega al archivo list_IPProhibited.txt.
#  En ambos casos previamente verifica que la IP no esté previamente cargada.
# - Opción 3: Lista las IP cargadas con su dominio.
# - Opción 4: Permite borrar una linea del archivo texto preguntando por el dominio o por la IP.
# - Opción 5: Salir
# Entregar los textos de los scripts, luego de probarlos. De ser factible realizar capturas
# de pantallas y agregarlas en la entrega.
###########################################################################################################


while true; do
    # Verificar si la IP está en la lista de IP prohibidas
    while read ip; do      
     if [ -n "${ip}" ]; then   #contraria a -z . unset = false, empty = false, non.empty = true
        echo "Monitoreando $ip" 
        netstat -tupan | grep $ip > "$ip-List.log" #envia a un log las conexiones con una ip prohibida
        cat "$ip-List.log"
        while IFS=' ' read  proto  recib enviad dirLocal dirRemota estado PID  
         do 
           nameProg=$(echo $PID | cut -d '/' -f 2)
           PID=$(echo $PID | cut -d '/' -f 1)
           user=$(ps -u -p $PID | awk '{print $1}')
           echo $user
           echo "Proceso: $nameProg PID: $PID"
           who | grep $user | cut -d' ' -f1,3 > "session.log"
           cat "session.log"
          
                  echo "IP Prohibido: $user,  $dirRemota $PID $nameProg" 
                  # Enviar mail al root
                  echo "IP Prohibido: $user, $date $dirRemota $PID $nameProg" | mail -s "IP Prohibido" root@localhost         
                  # Desplegar cartel en pantalla             
                  while IFS=' ' read u s; do
                    echo "La ip: $ip esta prohibida. Se ha informado al administrador. Se cierra la conexion." | write $u $s
                  done < "session.log"
                  #Cortar la conexión
                  pkill -9 $PID
        done < "$ip-List.log"
      fi 
    done < /control/list_IPProhibited.txt
 sleep 60 
done
