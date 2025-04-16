# Proyecto 2

## Autores
- Erick Guerra  
- Fabian Morales  
- Fernando Ruiz  

## 📅 Fecha de entrega
15/04/2025

## 🎯 Descripción
Este programa simula reservas concurrentes de asientos para un evento en una base de datos PostgreSQL. Utiliza múltiples hilos para representar usuarios intentando reservar **el mismo grupo de asientos al mismo tiempo**, permitiendo observar el comportamiento de las transacciones bajo diferentes **niveles de aislamiento**.

## 🛠️ Requisitos

- Python 3.8 o superior
- PostgreSQL
- Paquete `psycopg2` para conectarse a la base de datos

Instalar `psycopg2`:

```bash
pip install psycopg2
```

## 🗃️ Archivos importantes

- `experimentacion.py` — Script principal con la lógica de concurrencia.
- `ddl.sql` — Script para crear la estructura de la base de datos.
- `data.sql` — Script para insertar datos iniciales (eventos, clientes, etc.).

## ⚙️ Configuración de conexión

Antes de ejecutar el programa, edita el archivo `experimentacion.py` y cambia la sección `DB_CONFIG` con los datos correctos de tu instalación de PostgreSQL:

```python
DB_CONFIG = {
    'dbname': 'eventos',
    'user': 'tu_usuario',         # ← Cambia esto por tu usuario
    'password': 'tu_contraseña',  # ← Cambia esto por tu contraseña
    'host': 'localhost',
    'port': 5432
}
```

## 🏁 Instrucciones de uso

### 1. Crear la base de datos y las tablas

Ejecuta los siguientes scripts en PostgreSQL, usando tu cliente favorito (`psql`, PgAdmin, DBeaver, etc.):

```sql
-- Crear estructura
\i ddl.sql

-- Insertar datos de prueba
\i data.sql
```

### 2. Ejecutar la simulación

En terminal o desde tu editor, corre el archivo:

```bash
python experimentacion.py
```

El programa simulará reservas bajo distintos niveles de aislamiento y números de usuarios concurrentes.

### 3. ¿Qué hace el programa?

Por cada combinación de escenario:

- **Reinicia la base de datos** (elimina reservas previas y marca asientos como disponibles).
- **Lanza hilos simultáneos** que intentan reservar asientos aleatorios dentro de un rango.
- **Imprime resultados** de reservas exitosas, fallidas y el tiempo total de ejecución.

## 📌 Consideraciones

- Solo hay 6 clientes creados (ID del 1 al 6).
- Cada hilo representa un intento de reserva por un cliente.
- La disponibilidad de los asientos se reinicia antes de cada prueba.

