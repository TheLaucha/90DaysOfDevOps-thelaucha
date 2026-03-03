#!/bin/bash
# Script de despliegue automatizado para Book Library
set -e

# Variables globales
APP_DIR="devops-static-web"
LOG_FILE="deploy.log"

instalar_dependencias(){
    echo "=== Instalando dependencias del sistema ==="
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv nginx git net-tools
    sudo systemctl enable nginx
    sudo systemctl start nginx
}

clonar_app(){
    echo "=== Clonando aplicacion ==="
    if [ ! -d "$APP_DIR" ]; then
        git clone -b booklibrary https://github.com/roxsross/devops-static-web.git
    fi
    # Nos movemos a la carpeta SIEMPRE para asegurar el contexto
    cd "$APP_DIR"
}

configurar_entorno(){
    echo "=== Configurando entorno virtual ==="
    python3 -m venv venv
    ./venv/bin/pip install --upgrade pip
    ./venv/bin/pip install -r requirements.txt
    ./venv/bin/pip install gunicorn
}

configurar_gunicorn(){
    echo "=== Iniciando Gunicorn ==="
    # Detenemos si ya existe uno corriendo para evitar conflictos
    pkill -f gunicorn || true
    
    # Lanzamos en background
    nohup ./venv/bin/gunicorn -w 4 -b 0.0.0.0:8000 library_site:app > gunicorn.log 2>&1 &
    sleep 5 # Damos tiempo para que levante
}

configurar_nginx(){
    echo "=== Configurando Nginx ==="
    sudo rm -f /etc/nginx/sites-enabled/default
    
    # Usamos sudo tee para escribir el archivo con permisos
    sudo tee /etc/nginx/sites-available/booklibrary > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location /static/ {
        alias $(pwd)/static/;
        expires 30d;
    }
}
EOF

    sudo ln -sf /etc/nginx/sites-available/booklibrary /etc/nginx/sites-enabled/
    sudo nginx -t
    sudo systemctl reload nginx
}

verificar_servicios(){
    echo "=== Verificando servicios ==="
    
    # Nginx
    if systemctl is-active --quiet nginx; then
        echo "✅ Nginx está activo"
    else
        echo "❌ Error: Nginx no está activo"
        exit 1
    fi

    # Gunicorn
    if pgrep -f "gunicorn.*library_site" > /dev/null; then
        echo "✅ Gunicorn está corriendo"
    else
        echo "❌ Error: Gunicorn no está corriendo"
        exit 1
    fi

    # Puerto 8000
    if netstat -tlnp | grep -q ":8000"; then
        echo "✅ Puerto 8000 está en uso"
    else
        echo "❌ Error: Puerto 8000 no responde"
        exit 1
    fi
}

main(){
    echo "=== Iniciando despliegue de Book Library ==="
    instalar_dependencias
    clonar_app
    configurar_entorno
    configurar_gunicorn
    configurar_nginx
    verificar_servicios

    echo "=== Despliegue finalizado con éxito ==="
    echo "La aplicación debería estar disponible en: http://$(hostname -I | awk '{print $1}')"
}

main
