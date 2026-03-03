#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Debe enviar 2 argumentos"
	echo "Uso $0 archivo.txt palabra"
	exit 1
fi

ARCHIVO="$1"
PALABRA="$2"

if [ -f "$ARCHIVO" ]; then
	linea=$( grep "$PALABRA" $ARCHIVO )
	if [ ! -z "$linea" ]; then
		echo "Encontrado!"	
	else
		echo "No encontrado"
	fi
fi
