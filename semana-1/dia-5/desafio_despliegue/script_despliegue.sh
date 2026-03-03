#!/bin/bash

set -e

APP_NAME="ecommerce-app"
PROJECT_DIR="/home/vagrant/desafio_despliegue/devops-static-web"

sudo apt update

# Verificar e instalar node y npm
if ! command -v node >/dev/null 2>&1; then
	curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
	sudo apt install -y nodejs
	# Verificar
	node -v
	npm -v
fi

# Verificar e instalar PM2
if ! command -v pm2 >/dev/null 2>&1; then
	sudo npm install -g pm2
fi

# Verificar y clonar repo
if [ ! -d "devops-static-web" ]; then
	git clone -b ecommerce-ms https://github.com/roxsross/devops-static-web.git
fi
cd devops-static-web
git fetch
git checkout ecommerce-ms
git pull origin ecommerce-ms

# Definir y levantar microservicios
SERVICES=("merchandise" "products" "frontend" "shopping-cart")
for SERVICE in "${SERVICES[@]}"; do
	echo "Deployando $SERVICE"
	
	SERVICE_PATH="$PROJECT_DIR/$SERVICE"
	
	if [ ! -f "$SERVICE_PATH/package.json" ]; then
		echo "No existe package.json en $SERVICE"
		continue
	fi

	npm install --prefix "$SERVICE_PATH"

	if pm2 describe "$SERVICE" >/dev/null 2>&1; then
		pm2 restart "$SERVICE"
	else
		pm2 start npm --name "$SERVICE" --cwd "$SERVICE_PATH" -- start
	fi

	# Vuelvo a la carpeta anterior
	cd ..	
done

# Instalar dependencias
npm install

# Levantar con PM2
if pm2 describe ecommerce-app >/dev/null 2>&1; then
	pm2 restart ecommerce-app
else
	pm2 start npm --name "ecommerce-app" -- start
fi


# Guardar config para reinicio automatico
pm2 save
pm2 startup


