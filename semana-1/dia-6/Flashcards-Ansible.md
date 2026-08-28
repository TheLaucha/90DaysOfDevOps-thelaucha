# 🎴 Flashcards — Ansible (Repaso para Entrevistas)

> Cómo usar: cada tarjeta tiene la pregunta a la vista. Hacé clic en **"Ver respuesta"** para desplegarla.
> Compatible con GitHub, Notion (al pegarlo puede requerir convertir a toggle) y la mayoría de visores Markdown que soportan HTML embebido (`<details>`).

---

### 1. ¿Qué significa que Ansible sea "agentless"?

<details>
<summary>Ver respuesta</summary>

No requiere instalar software adicional en los nodos gestionados, solo **SSH + Python**.

Ansible se conecta por SSH a los managed nodes y ejecuta los módulos usando el Python ya presente en el sistema, sin instalar ningún demonio o agente permanente (a diferencia de Puppet o Chef).
</details>

---

### 2. ¿Qué es la idempotencia en Ansible?

<details>
<summary>Ver respuesta</summary>

Ejecutar el mismo playbook varias veces produce siempre el mismo resultado final, sin repetir acciones innecesarias.

Si un paquete ya está instalado, Ansible reporta `ok` en vez de reinstalarlo. Solo aplica los cambios que realmente faltan.
</details>

---

### 3. ¿Cuál es la diferencia entre Control Node y Managed Node?

<details>
<summary>Ver respuesta</summary>

El **Control Node** tiene Ansible instalado y ejecuta los comandos; el **Managed Node** solo necesita SSH y Python.

El Control Node es la máquina desde donde corrés `ansible-playbook`. Los Managed Nodes son los servidores que se configuran, sin necesidad de tener Ansible instalado en ellos.
</details>

---

### 4. ¿Qué es un Playbook?

<details>
<summary>Ver respuesta</summary>

Un archivo YAML que define qué tareas ejecutar, en qué hosts y con qué permisos.

Es la "receta" de automatización: incluye hosts objetivo, si escala privilegios (`become`), y la lista de tasks o roles a aplicar.
</details>

---

### 5. ¿Qué es un módulo en Ansible? Dá un ejemplo.

<details>
<summary>Ver respuesta</summary>

Una unidad de acción reutilizable. Ejemplos: `apt`, `copy`, `service`, `user`.

Los módulos son la unidad mínima de trabajo: cada tarea invoca un módulo con parámetros. Ansible trae cientos de módulos incorporados para paquetes, servicios, archivos, cloud, etc.
</details>

---

### 6. ¿Qué problema resuelve un Rol (role) en Ansible?

<details>
<summary>Ver respuesta</summary>

Empaqueta tareas, plantillas y variables relacionadas con una misma responsabilidad, para reutilizarlas entre proyectos.

Un rol organiza todo lo necesario para una tarea concreta (ej: "nginx") en una estructura de carpetas estándar (`tasks/`, `templates/`, `handlers/`), evitando playbooks gigantes e ilegibles.
</details>

---

### 7. ¿Qué es un Handler y cuándo se ejecuta?

<details>
<summary>Ver respuesta</summary>

Una tarea que solo se ejecuta si otra tarea la notifica con un cambio real (`changed`).

Se usa típicamente para reiniciar un servicio solo cuando su configuración cambió de verdad, evitando reinicios innecesarios en cada ejecución del playbook.
</details>

---

### 8. ¿Qué es un comando "ad-hoc" en Ansible?

<details>
<summary>Ver respuesta</summary>

Una ejecución puntual de una sola tarea sin necesidad de escribir un playbook completo.

Ejemplo: `ansible webservers -m ping`. Se usa para tareas rápidas o de prueba; los playbooks se usan cuando la tarea debe ser repetible y documentada.
</details>

---

### 9. ¿Para qué sirve el flag `--check` al ejecutar un playbook?

<details>
<summary>Ver respuesta</summary>

Simula la ejecución sin aplicar cambios reales (**dry run**), mostrando qué cambiaría.

Es una "vista previa" segura antes de aplicar cambios en real, muy útil en producción. Se puede combinar con `--diff` para ver exactamente qué líneas cambiarían.
</details>

---

### 10. ¿Cuál es la diferencia entre los módulos `copy` y `template`?

<details>
<summary>Ver respuesta</summary>

`copy` mueve un archivo tal cual; `template` usa **Jinja2** para insertar variables antes de copiarlo.

`template` permite generar un mismo archivo adaptado a cada host (ej: insertar el hostname o una IP) usando variables como `{{ inventory_hostname }}`.
</details>

---

### 11. Al configurar un firewall con `ufw` en un playbook, ¿en qué orden deben ir las tareas de "allow" y "enabled con policy deny"?

<details>
<summary>Ver respuesta</summary>

Primero permitir los puertos necesarios (`allow`), después habilitar la política `deny`.

Si se activa `deny` antes de permitir el puerto SSH, se corre el riesgo de perder el acceso remoto al servidor entre una tarea y la otra.
</details>

---

### 12. ¿Qué hace la keyword `loop` en una tarea de Ansible?

<details>
<summary>Ver respuesta</summary>

Repite la misma tarea con distintos valores, evitando duplicar código.

Ejemplo: abrir varios puertos de firewall (22, 80, 443) con una sola tarea usando `loop: [22, 80, 443]` en vez de escribir tres tareas iguales.
</details>

---

### 13. ¿Qué hace la keyword `when` en una tarea?

<details>
<summary>Ver respuesta</summary>

Ejecuta la tarea solo si se cumple una condición.

Ejemplo: `when: ansible_distribution == "Ubuntu"` para que una tarea solo se aplique en ese sistema operativo específico.
</details>

---

### 14. ¿Qué es Ansible Vault y para qué se usa?

<details>
<summary>Ver respuesta</summary>

Una herramienta para **cifrar información sensible** (contraseñas, tokens) dentro de archivos versionados en Git.

Evita el mal hábito de dejar contraseñas o claves API en texto plano dentro de un playbook que se sube a un repositorio.
</details>

---

### 15. Además de crear el usuario con `user`, ¿qué falta para que ese usuario pueda conectarse por SSH sin contraseña?

<details>
<summary>Ver respuesta</summary>

Agregar su clave pública con el módulo **`authorized_key`**.

Crear el usuario no habilita ningún método de acceso por sí solo. Hay que sumar `authorized_key` (clave pública) o una contraseña hasheada correctamente.
</details>

---

### 16. En una estructura de proyecto profesional con roles, ¿qué keyword reemplaza a `tasks:` en el playbook principal para invocar roles completos?

<details>
<summary>Ver respuesta</summary>

**`roles:`**

Con `roles:` Ansible busca automáticamente `roles/<nombre>/tasks/main.yml` sin necesidad de indicar rutas manualmente.
</details>

---

### 17. ¿Qué diferencia hay entre `group_vars/` y las `vars` dentro de un rol?

<details>
<summary>Ver respuesta</summary>

`group_vars` aplica a un grupo entero de hosts del inventario; las `vars` de un rol aplican solo a ese rol.

`group_vars` es útil para valores que cambian según el entorno (ej: producción vs staging), mientras que las vars de un rol son específicas de esa responsabilidad puntual.
</details>

---

## 📌 Notas de uso

- Este archivo usa la etiqueta HTML `<details>`/`<summary>`, soportada de forma nativa por Markdown en **GitHub**, **VS Code** (preview) y la mayoría de visores web.
- **En Notion**: al importar el `.md`, es posible que el toggle no se reconozca automáticamente. Si eso pasa, podés recrear cada tarjeta como un bloque **Toggle List** de Notion (escribí la pregunta, dale Enter, y dentro del toggle pegá la respuesta) — es rápido de rehacer a mano si el import no lo respeta.
- Podés agregar tarjetas nuevas copiando el mismo patrón: `### N. Pregunta` seguido del bloque `<details><summary>Ver respuesta</summary> ... </details>`.
