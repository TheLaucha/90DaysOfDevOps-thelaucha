#!/bin/bash

# Salir si hay un error
set -e

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update -y

# Instalar Nginx
echo "Instalando Nginx..."
sudo apt install nginx -y

# Habilitar y arrancar el servicio de Nginx
echo "Habilitando y arrancando el servicio de Nginx..."
sudo systemctl enable nginx
sudo systemctl start nginx

# Comprobar el estado del servicio de Nginx
echo "Comprobando el estado del servicio de Nginx..."
sudo systemctl status nginx

# Configurar Nginx para servir archivos estáticos
echo "Configurando Nginx para servir archivos estáticos..."
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Recargar la configuración de Nginx
echo "Recargando la configuración de Nginx..."
sudo systemctl reload nginx

echo "✅ Nginx instalado y corriendo."