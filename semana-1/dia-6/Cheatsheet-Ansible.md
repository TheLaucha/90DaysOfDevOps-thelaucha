# 📋 Cheatsheet — Ansible

> Formato: **Concepto** → **Explicación resumida** → **Ejemplo / caso de uso**

---

## 🧠 Conceptos Fundamentales

### Infraestructura como Código (IaC)
Definir y gestionar servidores mediante archivos de código versionables, en vez de configurarlos a mano uno por uno.

```
Sin IaC: entrar por SSH a 10 servidores y repetir comandos.
Con IaC: escribir el playbook una vez, aplicarlo a los 10 a la vez.
```

### Idempotencia
Ejecutar el mismo playbook varias veces produce siempre el mismo resultado final; Ansible solo aplica lo que falta, no repite acciones innecesarias.

```
Si nginx ya está instalado → Ansible reporta "ok" (no "changed").
Si falta instalarlo → lo instala y reporta "changed".
```

### Agentless
Ansible no requiere instalar software adicional en los nodos gestionados — solo SSH + Python en el destino.

```
Control Node (con Ansible instalado) ──SSH──> Managed Nodes (solo SSH + Python)
```

---

## 🏗️ Arquitectura

### Control Node
La máquina donde está instalado Ansible y desde donde se ejecutan playbooks/comandos.

```bash
# Se instala una sola vez, acá:
sudo apt install ansible
```

### Managed Nodes
Servidores gestionados. No necesitan agente, solo acceso SSH y Python.

```
Requisitos mínimos en el nodo:
- Servicio SSH corriendo
- Python 3 instalado
- Usuario con permisos (idealmente con sudo sin contraseña para automatizar)
```

---

## 📦 Componentes

### Inventario
Lista de hosts gestionados, organizados en grupos.

```ini
[webservers]
node1 ansible_host=192.168.1.10 ansible_user=admin

[databases]
db01.example.com
```

### Playbook
Archivo YAML que define qué tareas ejecutar, en qué hosts y con qué permisos.

```yaml
---
- name: Configurar servidor
  hosts: webservers
  become: yes
  tasks:
    - name: Instalar git
      apt:
        name: git
        state: present
```

### Módulo
Unidad de acción reutilizable que ejecuta una tarea específica (instalar paquete, copiar archivo, gestionar servicio, etc.).

```yaml
apt:      # gestor de paquetes Debian/Ubuntu
copy:     # copiar archivo tal cual
template: # copiar archivo con variables Jinja2
service:  # iniciar/detener/habilitar servicios
user:     # crear/gestionar usuarios
ufw:      # gestionar firewall
```

### Rol
Paquete reutilizable de tareas, plantillas y variables relacionadas con una misma responsabilidad (ej: todo lo de Nginx).

```
roles/nginx/
├── tasks/main.yml      → qué hacer
├── templates/index.j2  → archivos con variables
└── handlers/main.yml   → acciones disparadas por notify
```

### Handler
Tarea que solo se ejecuta si otra tarea la "notifica" con un cambio real (`changed`), útil para reiniciar servicios solo cuando hace falta.

```yaml
tasks:
  - name: Desplegar config
    template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    notify: Reiniciar nginx

handlers:
  - name: Reiniciar nginx
    service:
      name: nginx
      state: restarted
```

---

## 💻 Comandos Esenciales

### Comando Ad-Hoc
Ejecución puntual de una sola tarea, sin necesidad de escribir un playbook completo. Útil para pruebas rápidas.

```bash
ansible webservers -m ping -u admin
ansible all -m apt -a "name=nginx state=present" -b
```

### Ejecutar un Playbook
Corre el archivo YAML completo contra el inventario indicado.

```bash
ansible-playbook -i inventory.ini playbook.yml
```

### Pedir contraseña de sudo interactivamente
Cuando el usuario necesita contraseña para escalar privilegios y no está configurado `NOPASSWD`.

```bash
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```

### Modo verboso (debugging)
Muestra el detalle de la ejecución, útil cuando una tarea falla sin razón obvia.

```bash
ansible-playbook playbook.yml -vvv
```

### Check Mode (Dry Run)
Simula la ejecución sin aplicar cambios reales — muestra qué cambiaría.

```bash
ansible-playbook playbook.yml --check --diff
```

### Validar sintaxis sin ejecutar
Revisa que el YAML y la estructura del playbook sean correctos antes de tocar servidores.

```bash
ansible-playbook playbook.yml --syntax-check
```

### Listar tareas sin ejecutarlas
Muestra el orden de ejecución de tareas/roles, útil para revisar playbooks con roles antes de aplicarlos.

```bash
ansible-playbook playbook.yml --list-tasks
```

### Ejecutar solo tareas con un tag específico
Permite iterar rápido sobre un rol o bloque puntual sin correr todo el playbook.

```bash
ansible-playbook playbook.yml --tags nginx
```

---

## 🔧 Módulos Clave con Ejemplo

### `apt` — gestión de paquetes
```yaml
- name: Instalar paquetes
  apt:
    name: ["git", "htop", "nginx"]
    state: present
    update_cache: yes
```

### `copy` — copiar archivo tal cual
```yaml
- name: Copiar configuración
  copy:
    src: files/config.conf
    dest: /etc/app/config.conf
```

### `template` — copiar archivo con variables (Jinja2)
```yaml
- name: Desplegar página con datos dinámicos
  template:
    src: index.html.j2       # contiene {{ variables }}
    dest: /var/www/html/index.html
```

### `service` — gestionar servicios
```yaml
- name: Asegurar nginx corriendo
  service:
    name: nginx
    state: started
    enabled: yes
```

### `user` — crear/gestionar usuarios
```yaml
- name: Crear usuario con sudo
  user:
    name: devops
    groups: sudo
    append: yes
    shell: /bin/bash
```

### `authorized_key` — agregar clave SSH a un usuario
```yaml
- name: Dar acceso SSH por clave pública
  authorized_key:
    user: devops
    key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"
```

### `lineinfile` — editar una línea específica de un archivo
```yaml
- name: Deshabilitar login root por SSH
  lineinfile:
    path: /etc/ssh/sshd_config
    line: "PermitRootLogin no"
```

### `ufw` — reglas de firewall
```yaml
- name: Permitir puertos necesarios
  ufw:
    rule: allow
    port: "{{ item }}"
    proto: tcp
  loop:
    - 22
    - 80
    - 443

- name: Habilitar firewall con política deny
  ufw:
    state: enabled
    policy: deny
```
> ⚠️ Regla de oro: **siempre** abrí los puertos necesarios (loop de `allow`) **antes** de habilitar la política `deny`, para no perder acceso SSH en el proceso.

---

## 🔁 Control de Flujo

### `loop` — repetir una tarea con distintos valores
Evita repetir código cuando la misma acción se aplica a varios valores.

```yaml
- name: Instalar varios paquetes
  apt:
    name: "{{ item }}"
    state: present
  loop:
    - git
    - curl
    - htop
```

### `when` — condicionales
Ejecuta una tarea solo si se cumple una condición.

```yaml
- name: Instalar solo en Ubuntu
  apt:
    name: nginx
  when: ansible_distribution == "Ubuntu"
```

### Variables (`vars`)
Valores reutilizables dentro de un playbook o rol, para no hardcodear datos.

```yaml
vars:
  deploy_user: devops
  http_port: 8080

tasks:
  - name: Crear usuario
    user:
      name: "{{ deploy_user }}"
```

---

## 📂 Estructura Profesional de Proyecto

| Carpeta/Archivo | Función |
|---|---|
| `inventories/<entorno>/hosts.ini` | Hosts separados por entorno (staging, production) |
| `roles/<nombre>/tasks/main.yml` | Tareas del rol (se detectan automáticamente) |
| `roles/<nombre>/templates/` | Plantillas Jinja2 del rol |
| `roles/<nombre>/handlers/main.yml` | Handlers del rol |
| `playbook.yml` | Orquesta qué roles aplicar y a qué hosts |
| `group_vars/<grupo>.yml` | Variables aplicadas a todo un grupo de hosts |
| `ansible.cfg` | Configuración del proyecto (inventario default, usuario SSH, etc.) |

```yaml
# playbook.yml usando roles
---
- name: Desplegar aplicación
  hosts: webservers
  become: yes
  roles:
    - devops
    - firewall
    - nginx
```

---

## ⚠️ Buenas Prácticas / Errores Comunes

| Situación | Recomendación |
|---|---|
| Contraseñas en el playbook | Nunca en texto plano → usar **Ansible Vault** para cifrarlas |
| Orden de firewall | Abrir puertos (`allow`) **antes** de habilitar `deny` por defecto |
| `{{ item }}` en el `name` de una tarea con `loop` | Puede tirar warning "item is undefined" — usar `loop_control: label:` o dejar el name genérico |
| Usuario sin forma de conectarse | Crear el usuario **no** alcanza — hay que sumar `authorized_key` (SSH) o contraseña hasheada |
| Reiniciar servicios innecesariamente | Usar `handlers` con `notify`, no poner `service: state=restarted` como tarea fija |
| Rutas dentro de un rol | Dentro de `roles/<nombre>/tasks/main.yml`, las rutas a `templates/` son relativas al rol — no hace falta escribir `templates/archivo.j2`, solo `archivo.j2` |

---

## 🔜 Para seguir profundizando

- **Ansible Vault** → cifrar contraseñas y secretos en archivos versionados
- **`group_vars/` vs `vars/` de un rol** → alcance de las variables según el nivel
- **`loop_control: label:`** → personalizar el output de tareas con loop
- **Ansible Galaxy** → roles ya hechos por la comunidad (docker, nodejs, etc.)
- **`--tags` / `--list-tasks`** → iterar más rápido durante el desarrollo de playbooks con roles
