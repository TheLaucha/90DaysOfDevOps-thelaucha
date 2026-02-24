# Proyecto Vagrant con Nginx

## Sobre este proyecto

Este proyecto forma parte del día 3 del programa "90 Días DevOps" y consiste en la configuración de una máquina virtual Ubuntu usando Vagrant para servir un sitio web estático con Nginx. El proyecto demuestra conceptos básicos de infraestructura como código (IaC) y automatización del aprovisionamiento de servidores.

El proyecto incluye una página web de portafolio basada en Bootstrap que se sirve automáticamente a través de Nginx una vez que se levanta la máquina virtual.

## Qué es Vagrant

Vagrant es una herramienta de HashiCorp que permite crear y configurar entornos de desarrollo virtualizados de manera reproducible. Con Vagrant puedes:

- **Definir infraestructura como código**: Usar archivos de configuración para especificar cómo debe ser la máquina virtual
- **Automatizar el aprovisionamiento**: Ejecutar scripts automáticamente durante la creación de la VM
- **Garantizar consistencia**: Todos los desarrolladores pueden tener exactamente el mismo entorno
- **Simplificar la gestión**: Comandos simples para crear, destruir y gestionar VMs

## Requisitos

Antes de usar este proyecto, asegúrate de tener instalado:

- **VirtualBox** (o VMware): Proveedor de virtualización
- **Vagrant**: Versión 2.0 o superior
- **Sistema operativo**: Windows, macOS o Linux

### Instalación rápida

```bash
# Windows (usando Chocolatey)
choco install vagrant virtualbox

# macOS (usando Homebrew)
brew install vagrant virtualbox

# Ubuntu/Debian
sudo apt update
sudo apt install vagrant virtualbox
```

## Estructura del proyecto

```
01-vagrant-tarea/
├── Vagrantfile             # Configuración principal de Vagrant
├── scripts/
│   └── instalar_nginx.sh   # Script de aprovisionamiento
└── web/                    # Contenido del sitio web
```

### Descripción de archivos clave

- **`Vagrantfile`**: Archivo de configuración que define la VM Ubuntu 22.04, configuración de red y aprovisionamiento
- **`scripts/instalar_nginx.sh`**: Script bash que automatiza la instalación y configuración de Nginx
- **`web/`**: Directorio que contiene un sitio web de portafolio con Bootstrap que se sincroniza con `/var/www/html`

## Scripts de aprovisionamiento

### instalar_nginx.sh

Este script automatiza la configuración completa del servidor web:

## Cómo usarlo

### 1. Clonar/Descargar el proyecto

```bash
git clone <url-del-repositorio>
cd 01-vagrant-tarea
```

### 2. Levantar la máquina virtual

```bash
vagrant up
```

Este comando:

- Descarga la imagen Ubuntu 22.04 (solo la primera vez)
- Crea y configura la máquina virtual
- Ejecuta el aprovisionamiento automático
- Instala y configura Nginx
- Sincroniza la carpeta `web/` con `/var/www/html`

### 3. Acceder al sitio web

Una vez completado el proceso, puedes acceder al sitio web de las siguientes formas:

- **URL local**: http://localhost:8080
- **IP privada**: http://192.168.33.11
- **Desde dentro de la VM**: http://localhost

### 4. Conectarse a la máquina virtual

```bash
# Acceso SSH a la VM
vagrant ssh

# Ver logs de Nginx
sudo journalctl -u nginx -f

# Verificar estado del servicio
sudo systemctl status nginx
```

### 5. Comandos útiles de Vagrant

```bash
# Ver estado de la VM
vagrant status

# Recargar configuración (si cambias Vagrantfile)
vagrant reload

# Suspender la VM
vagrant suspend

# Reanudar VM suspendida
vagrant resume

# Reprovisionar (ejecutar scripts nuevamente)
vagrant provision
```

## Apagar y limpiar

### Apagar la máquina virtual

```bash
# Apagar gracefully
vagrant halt

# Suspender (más rápido para reanudar)
vagrant suspend
```

### Limpiar completamente

```bash
# Destruir la VM completamente
vagrant destroy

# Confirmar con 'y' cuando se solicite
# Esto libera todos los recursos pero mantiene los archivos del proyecto
```

### Limpiar archivos de Vagrant

```bash
# Eliminar cajas descargadas no utilizadas
vagrant box prune

# Listar todas las cajas instaladas
vagrant box list

# Eliminar una caja específica
vagrant box remove ubuntu/jammy64
```

## Aprendizajes clave

### 1. **Infraestructura como Código (IaC)**

- Definir la infraestructura en archivos de configuración versionables
- Reproducibilidad: cualquier persona puede recrear el mismo entorno
- Documentación implícita: la configuración ES la documentación

### 2. **Automatización del aprovisionamiento**

- Los scripts de shell permiten automatizar la configuración inicial
- Separación de responsabilidades: `Vagrantfile` para la VM, scripts para la aplicación

### 3. **Conceptos de red y virtualización**

- **Port forwarding**: Redirección del puerto 8080 del host al 80 del guest
- **Redes privadas**: IP estática 192.168.33.11 para acceso directo
- **Sincronización de carpetas**: Cambios en tiempo real entre host y guest

### 4. **Gestión de servicios Linux**

- Uso de `systemctl` para gestionar servicios
- Configuración de Nginx para servir contenido estático
- Logs y debugging de servicios

### 5. **Buenas prácticas DevOps**

- **Versionado**: Todo el código y configuración en control de versiones
- **Documentación**: README claro y completo
- **Automatización**: Mínima intervención manual
- **Reproducibilidad**: Entorno idéntico en cualquier máquina

### 6. **Comandos esenciales aprendidos**

```bash
# Vagrant
vagrant up/halt/destroy/ssh/status/reload

# Systemctl (gestión de servicios)
sudo systemctl start/stop/restart/status/enable nginx

# Debugging
sudo journalctl -u nginx -f
curl http://localhost
```

### 7. **Troubleshooting común**

- **Puerto ocupado**: Cambiar el puerto en `forwarded_port`
- **Permisos**: Verificar que los archivos web tengan permisos correctos
- **Servicio no arranca**: Revisar logs con `journalctl`
- **Red no accesible**: Verificar configuración de VirtualBox

---

## Próximos pasos

Este proyecto sienta las bases para:

- **Docker**: Containerización de aplicaciones
- **Kubernetes**: Orquestación de contenedores
- **Terraform**: Infraestructura en la nube
- **Ansible**: Gestión de configuración avanzada
- **CI/CD**: Pipelines de despliegue automatizado
