#!/bin/bash

#Configuramos los colores
rojo='\e[0;31m\033[1m'
sincolor='\033[0m'
cyan_luminoso='\033[1;36m'




# Llamamos a esta función desde el trap finalizar SIGINT (En caso de que el usuario presione control + c para salir)
finalizar() {
    echo -e "\e[1;31m\nFinalizando el script\e[0m"
    exit
}

trap finalizar SIGINT

#Comprobamos si es root
if [ $(id -u) -ne 0 ]; then
echo -e "${rojo}Tienes que ser root para ejecutarlo."
exit
fi

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

# verificamos que distribucion linux este usando
instalar_nmap() {
distribucion=$(cat /etc/*-release | grep "^ID=" | awk -F'=' '{print $2}' | tr -d '"')

# Empezamos con la instalacionen para cada una de las distibuciones de linux.
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

#Empezamos con las opciones de ejecucion de nmap , limpiamos pantalla y arrancamos.
clear
echo -e '┏┓╻┏┳┓┏━┓┏━┓   ┏━┓┏━╸┏━┓╻┏━┓╺┳╸   ┏━╸┏━┓┏━┓   ╺┳┓╻ ╻┏┳┓┏┳┓╻ ╻┏━┓
┃┗┫┃┃┃┣━┫┣━┛   ┗━┓┃  ┣┳┛┃┣━┛ ┃    ┣╸ ┃ ┃┣┳┛    ┃┃┃ ┃┃┃┃┃┃┃┗┳┛┗━┓
╹ ╹╹ ╹╹ ╹╹     ┗━┛┗━╸╹┗╸╹╹   ╹    ╹  ┗━┛╹┗╸   ╺┻┛┗━┛╹ ╹╹ ╹ ╹ ┗━┛
  
  
Script original por EL PINGUINO DE MARIO  https://github.com/maalfer
  
 \n
  '
  
read -p "Introduce la IP a escanear: " ip

read -p "Indica el nombre de salida del archivo: " nombre

while true; do
echo -e "\n1) Puertos abiertos con versiones y servicios "
echo "2) Buscar en los 65535 sin versiones ni servicios"
echo "3) Limitamos a los 100 puertos comunes"
echo "4) Buscamos vulnerabilidades scripts nse por defecto en todos los puertos"
echo "5) Escaneo de puertos UDP"
echo "6) Hay firewall? probemos."
echo "7) For CTF'S."
echo "8) Enumeracion share samba"
echo "9) Salir"
read -p "Selecciona una opción: " opcion

case $opcion in
1)
clear && echo "Escaneando..." && nmap -A $ip -oX $nombre > $nombre.txt && echo -e "${cyan_luminoso}Guardando el archivo $nombre.txt${sincolor}" && xsltproc $nombre > $nombre.html && echo -e "${cyan_luminoso}Convertido el archivo xml a html  ${sincolor}"
exit
;;

2)
clear && echo "Escaneando..." && nmap -p- -open $ip -oX $nombre > $nombre.txt && echo -e "${cyan_luminoso}Guardando el archivo $nombre.txt${sincolor}" && xsltproc $nombre > $nombre.html && echo -e "${cyan_luminoso}Convertido el archivo xml a html  ${sincolor}"
exit
;;

3)
clear && echo "Escaneando..." && nmap -p- --open --top-ports 100 $ip -oX $nombre > $nombre.txt && echo -e "${cyan_luminoso}Guardando el archivo $nombre.txt${sincolor}" && xsltproc $nombre > $nombre.html && echo -e "${cyan_luminoso}Convertido el archivo xml a html  ${sincolor}"
exit
;;

4)
clear && echo "Escaneando..." && nmap -p- -sV $ip -oX $nombre > $nombre.txt && echo -e "${cyan_luminoso}Guardando el archivo $nombre.txt${sincolor}" && xsltproc $nombre > $nombre.html && echo -e "${cyan_luminoso}Convertido el archivo xml a html  ${sincolor}"
exit
;;

5)
clear && echo "Escaneando..." && nmap -p- -sU $ip -oX $nombre > $nombre.txt && echo -e "${cyan_luminoso}Guardando el archivo $nombre.txt${sincolor}" && xsltproc $nombre > $nombre.html && echo -e "${cyan_luminoso}Convertido el archivo xml a html  ${sincolor}"
exit
;;

6)
clear && echo "Escaneando..." && nmap -sA $ip -oX $nombre > $nombre.txt && echo -e "${cyan_luminoso}Guardando el archivo $nombre.txt${sincolor}" && xsltproc $nombre > $nombre.html && echo -e "${cyan_luminoso}Convertido el archivo xml a html  ${sincolor}"
exit
;;

7)
clear && echo "Escaneando..." && nmap -p- -sS -sC -sV --min-rate=5000 -n -Pn $ip -oX $nombre > $nombre.txt && echo -e "${cyan_luminoso}Guardando el archivo $nombre.txt${sincolor}" && xsltproc $nombre > $nombre.html && echo -e "${cyan_luminoso}Convertido el archivo xml a html  ${sincolor}"
exit
;;

8)
clear && echo "Escaneando..." && nmap -p 139,445 --script smb-enum-shares $ip -oX $nombre > $nombre.txt && echo -e "${cyan_luminoso}Guardando el archivo $nombre.txt${sincolor}" && xsltproc $nombre > $nombre.html && echo -e "${cyan_luminoso}Convertido el archivo xml a html  ${sincolor}"
exit
;;

9)
break
;;

*)
echo -e "${rojo}\nOpción incorrecta, elige el tipo de escaneo correcto."${sincolor}
;;
esac
done