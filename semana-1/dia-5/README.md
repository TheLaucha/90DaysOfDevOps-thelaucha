# Día 5 - Automatizando Tareas con Bash Scripting

Clase enfocada en la automatización de tareas mediante scripts en Bash.

## Contenido de la clase

### Scripts iniciales
Scripts básicos para introducir conceptos: salida por consola, variables, condicionales y lectura de entrada.

### Scripts de tarea
Ejercicios prácticos que incluyen:
- Backups de logs con rotación automática
- Operaciones matemáticas (tablas, multiplicaciones)
- Búsqueda de palabras en archivos
- Cuestionarios interactivos

### Scripts avanzados
Monitores del sistema:
- **monitor_disco.sh** - Uso de espacio en disco
- **monitor_salud.sh** - Memoria, disco y CPU
- **monitor_servicio.sh** - Verificación y reinicio de servicios (ej. Apache)

### Funciones reutilizables
- `funciones.sh` - Define funciones como `crear_usuario`
- `gestion_usuarios.sh` - Script que utiliza las funciones para gestionar usuarios del sistema

### Reto bonus
Despliegue automatizado de la aplicación **Book Library** (Python/Flask) con Gunicorn y Nginx. El script `desplegar_app.sh` instala dependencias, clona el repo, configura el entorno virtual y el proxy reverso.

### Desafío final: `desafio_despliegue`
Reto que integra lo aprendido: despliegue de una aplicación ecommerce con múltiples microservicios (Node.js/Express) usando PM2. Incluye:
- `script_despliegue.sh` - Automatiza la instalación de Node.js, PM2, clonación del repo y despliegue de los servicios (frontend, products, shopping-cart, merchandise)
- `Vagrantfile` - Entorno Ubuntu para practicar con `vagrant up`

## Entorno de práctica

El `Vagrantfile` en la raíz configura una VM Ubuntu (bash-lab) con las herramientas básicas (curl, git, tree) para practicar bash scripting. El puerto 3000 de la VM se expone en el host como 8080.
