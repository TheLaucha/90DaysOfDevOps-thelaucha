#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "Debe enviar dos numeros para multiplicar"
	echo "Uso $0 5 2"
	exit 1
fi

resultado=$(( $1 * $2 ))

echo "$resultado"
