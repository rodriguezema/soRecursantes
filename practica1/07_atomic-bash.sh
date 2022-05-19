#!/bin/bash

# 7) ¿Como implementar un semáforo en BASH? Dentro de un fichero 07_atomic-bash.sh
# escriba un ejemplo.


counter=0
sem=1
loop=10000
############################################################################################
# Implementacion de un semaforo en bash con un contador                                    #
# Se crea una variable counter que se incrementa en 1 cada vez que se ejecuta              #
# el bucle. Cuando counter es igual a loop, se bloquea el semaforo.                        #
# Cuando counter es menor que loop, se desbloquea el semaforo.                             #
# Cuando counter es igual a loop, se incrementa counter y se desbloquea el semaforo.       #
############################################################################################
sem_wait() {  # Funcion que bloquea el semaforo
    while [ $sem -eq 0 ]; do
        sleep 0.1
    done
    ((sem--))
}

sem_post() {  # Funcion que desbloquea el semaforo
    ((sem++))
}

function incrementCS { # Funcion que incrementa el contador con semaforo
    if [ $sem = true ]; then
        for ((i=0; i<$loop; i++)); do
            sem_wait
            ((counter--))
            sem_post
        done    
    fi
}

function decrementCS { # Funcion que decrementa el contador con semaforo
    if [ $sem = true ]; then
        for ((i=0; i<$loop; i++)); do
            sem_wait
            ((counter--))
            sem_post
        done        
    fi
}

function incrementSS { # Funcion que incrementa el contador sin semaforo    
    for ((i=0; i<$loop; i++)); do
        ((counter++))
    done
}
function decrementSS { # Funcion que decrementa el contador sin semaforo
    for ((i=0; i<$loop; i++)); do
        ((counter--))
    done
}


clear
while true; do 
echo -e "\e[1;31m"
echo "Menu Semáforo en BASH"
echo -e "\e[1;32m"
echo "1. Sin Semáforo"
echo -e "\e[1;34m"
echo "2. Con Semáforo"
echo -e "\e[0m"
echo "3. Salir"
echo -e "\e[1;31m"
echo "Elige una opción: "
read opcion
echo -e "\e[0m"
echo " "
case $opcion in
    1)
        echo -e "\e[1;32m"
        echo "Ejecutando sin semáforo"
        echo " "
        echo "Inicializando contador..."
        counter=0
        echo "Contador: $counter"
        incrementSS &
        decrementSS 
        echo "Contador: $counter"
        ;;
    2)
        echo -e "\e[1;34m"
        echo "Ejecutando con semáforo"
        echo " "
        echo "Inicializando contador..."
        counter=0
        echo "Contador: $counter"
        incrementCS &
        decrementCS     
        echo "Contador: $counter"            
        ;;
    3)
        echo -e "\e[0m"
        echo "Saliendo..."
        break
        ;;
    *)
        echo -e "\e[1;33m"
        echo "Opción incorrecta"
        ;;
esac
done
echo " "
echo "Como se puede ver en la ejecución, el contador se incrementa y decrementa."
echo "Sin semáforo, el contador se incrementa y decrementa dando un valor distinto de 0."
echo "Con semáforo, el contador se incrementa y decrementa dando un valor igual a 0 cada ejecucion." 
echo "Fin del programa"
exit 0



