#/bin/bash

# Escriba un script que:
# a. Transforme los archivos .docx del directorio ./cartas a archivos en formato texto.
# (puede usar libreoffice en formato comando)
# b. Si la fecha de la carta está en el año 2021, la cambie a 2022
# c. Si la aclaración de firma de la carta dice “Decano Viejo” la cambie a “Decano
# Nuevo”
# d. Transforme los archivos textos modificados al formato .docx y los guarde en el
# directorio ./cartas/corregidas
# e. Envíe un mail con el listado de los archivos corregidos al root
##################################################################################

fecha=' '

random_date () {
   # Genera una fecha aleatoria para cada carta en el directorio cartas.
    let random=$((2021 + $RANDOM % 2)) #genero un numero aleatorio entre 2021 y 2022
    let nmes=$((1 + $RANDOM % 12)) #genero un mes aleatorio entre 1 y 12
    let ndia=$((1 + $RANDOM % 30)) #genero un dia aleatorio entre 1 y 30
    case $nmes in 
        "1") 
          mes="enero"
         ;;
        "2")  
           mes="febrero"
          ;;
        "3")  
           mes="marzo"
          ;;
        "4")  
           mes="abril"
          ;;
        "5")  
           mes="mayo"
          ;;
        "6")  
           mes="junio"
          ;;
        "7")  
           mes="julio"
          ;;
        "8")  
           mes="agosto"
          ;;
        "9")  
           mes="septiembre"
          ;;
        "10")  
           mes="octubre"
          ;;
        "11")  
           mes="noviembre"
          ;;
        "12")  
           mes="diciembre"
          ;;
    esac
    fecha="La Plata, $ndia de $mes de $random"
    echo "$fecha"
}




clear
echo "Ejercicio 5"
sleep 3

echo " "
sleep 1
if [ -d "./cartas" ] 
 then 
    echo "Borrando archivos .docx y .txt de la carpeta cartas"
    rm -rf ./cartas/*.docx  #borramos los archivos de cartas
    rm -rf ./cartas/*.txt  
    
 else
    echo "No existe la carpeta cartas, se crea ./cartas"
    mkdir ./cartas #creo el directorio si no existe
    mkdir ./cartas/papelera #creo el directorio trash
    mkdir ./cartas/corregidas #creo el directorio corregidas
fi
echo "  "

echo "Generando archivos en docx en Cartas"
echo "  "
sleep 1


while
     echo "Ingrese numero de cartas que desea generar" 
     read cant
       [[  ! "$cant" =~ ^[1-9][0-9]*$ ]] 
  do
    
    echo "$(tput setaf 3)ATENCION: Ingreso $cant, por favor ingrese un numero entero mayor o igual a 1$(tput setaf 7)"
   
done



for ((i=1; i<=$cant; i++)) #creo numero ingresado de  cartas .docx en el directorio ./cartas
 do  
    touch "./cartas/carta$i.docx"
    fecha=$(random_date)
    echo $fecha > "./cartas/carta$i.docx"
    echo "Archivo Cartas $i" >> "./cartas/carta$i.docx"
    lscpu >> "./cartas/carta$i.docx"
    echo " " >> "./cartas/carta$i.docx"
    echo " " >> "./cartas/carta$i.docx"
    echo " " >> "./cartas/carta$i.docx"
    echo "Firma:________________________________________" >> "./cartas/carta$i.docx"
    echo "Aclaración: Decano Viejo" >> "./cartas/carta$i.docx"
done


echo "Se generaron los siguientes archivos en formato docx en Cartas." 
sleep 1
ls ./cartas
echo " "
echo " "
read -n 1 -p "$(tput setaf 2)Presione una tecla para continuar...$(tput setaf 7)"
echo " "
sleep 1

date=$(date +%d-%m-%Y_%H%M) #fecha actual para versionar la correccion
for file in ./cartas/*.docx
do
 echo " "
 echo "Convirtiendo y corrigiendo $file"
 libreoffice --headless --convert-to txt:Text $file --outdir ./cartas #a.
 mv -t ./cartas/papelera --backup=numbered $file #Mueve a la papelera el archivo .docx sin corregir, con numeros de version.
 sed -i 's/2021/2022/g' ./cartas/*.txt #b.
 sed -i 's/Decano Viejo/Decano Nuevo/g' ./cartas/*.txt #c.
 echo "Se corrigio el archivo, se convertira a docx y enviara a ./cartas/corregidas/$date"
 libreoffice --headless --convert-to docx ./cartas/*.txt --outdir ./cartas/corregidas/$date #d. 
 mv -t ./cartas/papelera --backup=numbered ./cartas/*.txt    #Mueve a la papelera el archivo .txt corregido, con numeros de version.
 echo " "
done
  
   
echo "$(tput setaf 2)Se envia mail a root con lista de archivos corregidos$(tput setaf 7)"
echo "Listado de las cartas corregidas"> mail$date.txt 
ls -d ./cartas/corregidas/$date/* >> mail$date.txt 
cat mail$date.txt | mail -s "Listado de archivos corregidos" root@localhost   #e.

echo " "
echo " Fin del Script. Se cierra."
exit 0
