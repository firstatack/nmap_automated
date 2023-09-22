#!/bin/bash

rojo='\e[0;31m\033[1m'
sincolor='\033[0m'
cyan_luminoso='\033[1;36m'

if [ $(id -u) -ne 0 ]; then
echo -e "${rojo}Tienes que ser root para ejecutarlo."
exit
fi

# Función para instalar Nmap en diferentes distribuciones de Linux
instalar_nmap() {
distribucion=$(cat /etc/*-release | grep "^ID=" | awk -F'=' '{print $2}' | tr -d '"')

case $distribucion in
ubuntu|debian)
apt-get update
apt-get install -y nmap
;;
centos|fedora)
yum update
yum install -y nmap
;;
arch)
pacman -Syu --noconfirm nmap
;;
*)
echo -e "${rojo}No se pudo determinar la distribución de Linux. Por favor, instala Nmap manualmente.${sincolor}"
exit
;;
esac
}

# Verificar si Nmap está instalado
if ! command -v nmap &> /dev/null; then
echo -e "${cyan_luminoso}Nmap no está instalado.${sincolor}"
read -p "¿Deseas instalar Nmap ahora? (s/n): " respuesta
if [[ $respuesta =~ ^[Ss]$ ]]; then
instalar_nmap
else
echo -e "${rojo}Nmap es necesario para ejecutar este script. Por favor, instala Nmap y vuelve a intentarlo.${sincolor}"
exit
fi
fi

clear
read -p "Introduce la IP víctima: " ip

while true; do
echo -e "\n1) Escaneo rápido pero ruidoso"
echo "2) Escaneo normal"
echo "3) Escaneo lento y silencioso, siéntate tranquilo"
echo "4) Escaneo de servicios y versiones"
echo "5) Escaneo de puertos UDP"
echo "6) Escaneo de detección de sistemas operativos"
echo "7) Salir"
read -p "Selecciona una opción: " opcion
case $opcion in 

1)
clear && echo "Escaneando..." && nmap -p- -open -min-rate 5000 -T5 -sS -Pn -n -v $ip > escaneorapido.txt && echo -e "${cyan_luminoso}Guardando el archivo escaneorapido.txt${sincolor}"
exit
;;

2)
clear && echo "Escaneando..." && nmap -p- -open $ip > escaneobasico.txt && echo -e "${cyan_luminoso}Guardando el archivo escaneobasico.txt${sincolor}"
exit
;;

3) 
clear && echo "Escaneando..." && nmap -p- -T2 -sS -Pn $ip > escanelento.txt && echo -e "${cyan_luminoso}Guardando el archivo escanelento.txt${sincolor}"
exit
;;

4) 
clear && echo "Escaneando..." && nmap -p- -sV $ip > escaneoservice_versions.txt && echo -e "${cyan_luminoso}Guardando el archivo escaneoversiones.txt${sincolor}"
exit
;;

5)
clear && echo "Escaneando..." && nmap -p- -sU $ip > escaneoudp.txt && echo -e "${cyan_luminoso}Guardando el archivo escaneoudp.txt${sincolor}"
exit
;;

6)
clear && echo "Escaneando..." && nmap -O $ip > escaneosistemas.txt && echo -e "${cyan_luminoso}Guardando el archivo escaneosistemas.txt${sincolor}"
exit
;;

7)
break
;;

*)
echo -e "${rojo}\nOpción incorrecta, elige el tipo de escaneo correcto."${sincolor}
;;
esac
done
