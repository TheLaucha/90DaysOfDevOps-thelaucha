#!/bin/bash

source ./funciones.sh

if [ "$#" -ne 1 ]; then
	echo "Debe enviar un nombre de usuario como parametro"
	echo "Uso $0 username"
	exit 1
fi

crear_usuario "$1"
