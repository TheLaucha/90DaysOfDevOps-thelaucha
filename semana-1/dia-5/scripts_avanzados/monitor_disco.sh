#!/bin/bash

ADMIN="admin@ejemplo.com"
USO_RAIZ=$(df / | grep | awk '{print $5}' | sed 's/%//g')
TAMANO_HOME=$(du -sh /home | awk '{print $1}' | sed 's/G//g')

if [ "$USO_RAIZ" -ge 90 ]; then
	echo "¡Alerta: Particion / al ${USO_RAIZ}%!" | mail -s "Alerta Particion /" $ADMIN
fi

if (( $(echo "$TAMANO_HOME > 2" | bc -l) )); then
	echo "¡Alerta: /home ocupa ${TAMANO_HOME}GB!" | mail -s "Alerta Directorio /home" $ADMIN
fi
