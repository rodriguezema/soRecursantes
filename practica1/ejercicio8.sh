#!/bin/bash
#  Escriba un script que ejecutandonse en background, realize las siguientes funciones:
# - Detecte la inserción de un pendrive en un puerto USB.
# - Informe al root meditante mail y mensaje del suceso.
# - Informe al usuario que no está autorizado para usar Pendrives
# -
# Explique en un archivo texto que medidas debe tomar un administrador para garantizar que no
# se pueda montar un Pendrive por razones de seguridad, permitiendo montar otro tipo de
# dispositivos como un mouse.

#!/bin/bash
(
if  [  -d "./log" ]; then
    rm -rf ./log/*.log
 else
    mkdir log
fi

while true
 do
 #lista de los puertos USB
  devs=`ls -al /dev/disk/by-path/*usb*part* 2>/dev/null | awk '{print($11)}'`
  sleep 3
  montado=0
  for dev in $devs
  #bucle sobre los dispositivos usb, si estan conectados se guarda en una variable
  #sobre cada nombre de dispositivo y se comprueba si esta montado
     do 
         fecha=`date +%Y%m%d%H%M%S`
         log=./log/usb_$fecha.log
             
             dev=${dev##*\/}
             sleep 1
             echo "Se ha detectado una inserción de un pendrive en el puerto USB $dev" > $log
             echo "Se ha detectado un pendrive conectado por  $USER" >>$log
             montado=$( mount | grep $dev | awk '{print($3)}' ) > /dev/null 2>&1
             if [[ ! -z $montado  ]]
               then
                  echo -n "$dev Esta montado en: $montado"  >> $log
                 else
                  echo -n "$dev No esta montado" >> $log
               fi
             echo " " >> $log
             cat $log | mail -s "Pendrive detectado" root@localhost
             #se desatacha el pendrive si esta montado
             udisksctl power-off -b /dev/$dev > /dev/null 2>&1
             #se envia un mensaje por wall a cada usuario del sistema
             echo -e "\n############\nEl sistema no admite conexion ni montado de unidades de memoria usb.\nCada caso sera reportado al administrador.\n############\n" | wall
              
  done
done 
) &