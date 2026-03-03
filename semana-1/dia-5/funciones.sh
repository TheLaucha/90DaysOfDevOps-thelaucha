#!/bin/bash

crear_usuario(){
	if id "$1" &>/dev/null; then
		echo "El usuario $1 ya existe"
	else
		sudo useradd "$1"
		echo "Usuario $1 creado el $(date)" >> usuarios.log
		echo "Usuario $1 creado"
	fi
}
