#!/bin/bash

read -p "¿Tenes sed? (si/no): " RESPUESTA

if [ "$RESPUESTA" == "si" ]; then
	echo "Anda por un cafecito"
else
	echo "Seguimos con DevOps"
fi
