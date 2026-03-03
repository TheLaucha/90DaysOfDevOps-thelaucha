#!/bin/bash

ARCHIVO="config.txt"

if [ -f "$ARCHIVO" ]; then
	echo "El Archivo $ARCHIVO existe"
else
	echo "No encontre el archivo $ARCHIVO"
fi
