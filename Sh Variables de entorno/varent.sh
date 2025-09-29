#!/bin/bash
# Script que muestra variables del sistema (PATH, HOME, USER PROFILE) y modifica el valor de PATH

# Colores
verde=$(tput setaf 2)
azul=$(tput setaf 4)
amarillo=$(tput setaf 3)
reset=$(tput sgr0)

echo "======================================="
echo "${azul}     VARIABLES DEL SISTEMA${reset}"
echo "======================================="

echo "${amarillo}PATH actual:${reset}"
echo "$PATH"
echo "---------------------------------------"

echo "${amarillo}HOME:${reset} $HOME"
echo "${amarillo}USER PROFILE:${reset} $USERPROFILE"
echo "---------------------------------------"

echo "${azul}Variable propia:${reset}"
my_var="Hola mundo"
echo "my_var = $my_var"
echo "---------------------------------------"

# Modificar PATH
PATH="$PATH:/c/Users/usuario/script"

echo "${verde}PATH modificado:${reset}"
echo "$PATH"
echo "======================================="