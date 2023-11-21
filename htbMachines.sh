#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function crtl_c(){

  echo -e "\n\n${redColour}[!]${endColour} ${yellowColour}Saliendo...${endColour}\n"
  exit 1
}

#Crtl_c
trap crtl_c INT

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel(){
 echo -e "${blueColour}\n _   _ _____ ____       __  __  __    _    ____ _   _ ___ _   _ _____ ____  
| | | |_   _| __ )     / / |  \/  |  / \  / ___| | | |_ _| \ | | ____/ ___| 
| |_| | | | |  _ \    / /  | |\/| | / _ \| |   | |_| || ||  \| |  _| \___ \ 
|  _  | | | | |_) |  / /   | |  | |/ ___ \ |___|  _  || || |\  | |___ ___) |
|_| |_| |_| |____/  /_/    |_|  |_/_/   \_\____|_| |_|___|_| \_|_____|____/ 
                                                                by: 404azz ${endColour}"
 echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}"
 echo -e "\t${purpleColour}u)${endColour} ${grayColour}Actualizar o descargar archivos necesarios${endColour}"
 echo -e "\t${purpleColour}m)${endColour} ${grayColour}Buscar por un nombre de máquina${endColour}"
 echo -e "\t${purpleColour}i)${endColour} ${grayColour}Buscar máquina por dirección IP${endColour}"
echo -e "\t${purpleColour}d)${endColour} ${grayColour}Buscar máquina por dificultad${endColour}"
echo -e "\t${purpleColour}o)${endColour} ${grayColour}Buscar máquina por sistema operativo${endColour}"
echo -e "\t${purpleColour}s)${endColour} ${grayColour}Buscar por skills${endColour}"
echo -e "\t${purpleColour}y)${endColour} ${grayColour}Obtener enlace al vídeo de resolución de la máquina${endColour}"
 echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar este panel de ayuda${endColour}\n"
}

function updateFiles(){

  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n ${yellowColour}[+]${endColour} ${grayColour}Se descargarán los archivos necesarios${endColour}\n"
   curl -s $main_url > bundle.js
   js-beautify bundle.js | sponge bundle.js
  echo -e "\n${yellowColour}[+]${grayColour}Los archivos se han descargado con éxito!${endColour}"
  tput cnorm
else
  tput civis
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comprobando si hay actualizaciones penditenes...${endColour}"
  sleep 2
  curl -s $main_url > bundle_temp.js
  js-beautify bundle_temp.js | sponge bundle_temp.js
  md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
  md5_original_value=$(md5sum bundle.js | awk '{print $1}')

  if [ "$md5_temp_value" == "$md5_original_value" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Tienes la última actualización${endColour}"
    rm bundle_temp.js
  else
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se ha descargado la última actualización${endColour}"
    rm bundle.js && mv bundle_temp.js bundle.js
    tput cnorm
  fi

  fi
}

function searchMachine(){
  machineName="$1"
  machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')"

if [ "$machineName_checker" ]; then

echo -e "\n${blueColour}[+]${endColour} ${grayColour}Listando propiedades de la máquina${endColour} ${blueColour}$machineName${endColour}${grayColour}:${endColour}\n ${blueColor}$machineName_checker${endColour}\n"

else
  echo -e "\n${redColour}[!] La máquina no existe${endColour}\n"
fi

}

function searchIP(){
ipAdress="$1"
machineName=$(cat bundle.js | grep "ip: \"$ipAdress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '",')

if [ "$machineName" ]; then
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}La máquina correspondiente a la IP ${yellowColour}$ipAdress${endColour} ${grayColour}es${endColour} ${blueColour}$machineName${endColour}\n"
else
  echo -e "\n${redColour}[!] La IP proporcionada no es válida\n${endColour}"
fi
  }

function getYoutubeLink(){
  machineName="$1"

  youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"

if [ "$youtubeLink" ]; then

echo -e "\n${yellowColour}[+]${endColour} ${grayColour}El link a la máquina${blueColour} $machineName${endColour}${grayColour} es ${endColour}${blueColour}$youtubeLink${endColour}\n"
else

echo -e "\n${redColour} [!] La máquina proporcionada no existe o aún no está resuelta ${endColour}\n"

fi
  }

function getMachineDifficulty(){
difficulty="$1"

difficultyLevel="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 -i | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

if [ "$difficultyLevel"  ]; then

  echo -e "\n${blueColour}[+]${endColour} ${grayColour}Representado las máquinas con nivel de dificultad $difficulty:${endColour}\n ${blueColour}$difficultyLevel${endColour}\n"

else

  echo -e "\n${redColour}[!] Error al introducir la dificultad, las dificultades se representan como: Fácil, Media, Difícil o Insane\n\n[*] Recuerda las tildes\n"${endColour}

fi

  }

function getOperative(){
  so="$1"

  getOperative="$(cat bundle.js | grep "so: \"$so\"" -B 5 -i | grep "name: " | awk 'NF{print $NF}' | tr -d '",' | column)"

if [ "$getOperative" ]; then

  echo -e "\n${blueColour}[+]${endColour} ${grayColour}Filtrando por máquinas $so${endCOlour}\n ${blueColour}\n$getOperative${endColour}\n"

else

  echo -e "\n${redColour}[!] El sistema operativo introducido no es válido, los SO son: Windows o Linux\n${endColour}"
fi

  }

function getOSDifficultyMachines(){
  difficulty="$1"
  os="$2"

  getOSDifficultyMachines="$(cat bundle.js | grep "so: \"$os\"" -C 4 -i | grep "dificultad: \"$difficulty\"" -B 5 -i | grep "name: " | awk 'NF{print $NF}' | tr -d '",' | column)"

  if [ "$getOSDifficultyMachines" ]; then

    echo -e "\n${blueColour}[+]${endColour} ${grayColour}Mostrando el resultado de la búsqueda de máquinas con dificultad${endColour} ${blueColour}$difficulty${endColour} ${grayColour}y un sistema operativo${endColour} ${blueColour}$os${endColour}${grayColour}:\n${endColour}\n ${blueColour}$getOSDifficultyMachines\n${endColour}"

  else
    echo -e "\n${redColour}[!] Los filtros no se han aplicado correctamente\n${endColour}"
  fi

  }

function getSkill(){
  skill="$1"

  check_skill="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '",' | column)"

  if [ "$check_skill" ]; then

  echo -e "\n${blueColour}[+]${endColour} ${grayColour}Están son todas las máquinas que requieren${endColour} ${blueColour}$skill${endColour}${grayColour}:\n${endColour} \n${blueColour}$check_skill${endColour}\n"

  else
    echo -e "\n${redColour}[!] Skill inválida o aún no explotada${endColour}\n"
  fi
  }


# Chivatos
declare -i chivato_difficulty=0
declare -i chivato_so=0

# Indicadores
declare -i parameter_counter=0

while getopts "m:ui:y:d:o:s:h" arg; do
  case $arg in
  m) machineName="$OPTARG"; let parameter_counter+=1;;
  u) let parameter_counter+=2;;
  i) ipAdress="$OPTARG"; let parameter_counter+=3;;
  y) machineName="$OPTARG"; let parameter_counter+=4;;
  d) difficulty="$OPTARG"; chivato_difficulty=1; let parameter_counter+=5;;
  o) so="$OPTARG"; chivato_so=1; let parameter_counter+=6;;
  s) skill="$OPTARG"; let parameter_counter+=7;;
  h) ;;
  esac

done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAdress
elif [ $parameter_counter -eq 4 ]; then
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  getMachineDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
  getOperative $so
elif [ $parameter_counter -eq 7 ]; then
  getSkill "$skill"
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_so -eq 1 ]; then
  getOSDifficultyMachines $difficulty $so
else
  helpPanel
fi
