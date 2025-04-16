# Proyecto 2: Simulación de Hotspot en Reservas de Asientos
# Autor: Erick Guerra, Fabian Morales, Fernando Ruiz
# Fecha: 15/04/2025
# Descripción: Simulación de Hotspot en Reservas de Asientos
###################################################################
import psycopg2
import threading
import time
import random

DB_CONFIG = {
    'dbname': 'eventos',
    'user': 'tu_usuario',  # Cambia esto por tu usuario de postgres
    'password': 'tu_contraseña', # Cambia esto por tu contraseña de postgres
    'host': 'localhost',
    'port': 5432
}

evento_id = 1
resultados = {
    "exitosas": 0,
    "fallidas": 0
}

lock = threading.Lock()

def resetear_base(max_asiento):
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("BEGIN;")
        cursor.execute("DELETE FROM asientos_reserva;")
        cursor.execute("DELETE FROM reservas;")
        cursor.execute("UPDATE asientos SET disponible = true WHERE evento_id = %s AND numero <= %s;", (evento_id, max_asiento))
        conn.commit()
        cursor.close()
        conn.close()
        print(f"Base de datos reiniciada (asientos 1–{max_asiento})")
    except Exception as e:
        print(f"Error al reiniciar la base de datos: {e}")

def reservar_asiento(cliente_id, nivel_aislamiento, numero_asiento):
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.set_session(isolation_level=nivel_aislamiento)
        cursor = conn.cursor()
        cursor.execute("BEGIN;")

        cursor.execute("""
            SELECT id, disponible FROM asientos 
            WHERE evento_id = %s AND numero = %s 
            FOR UPDATE;
        """, (evento_id, numero_asiento))
        row = cursor.fetchone()

        if not row or not row[1]: 
            with lock:
                resultados["fallidas"] += 1
            conn.rollback()
        else:
            asiento_id = row[0]
            cursor.execute("INSERT INTO reservas (evento_id, cliente_id) VALUES (%s, %s) RETURNING id;", (evento_id, cliente_id))
            reserva_id = cursor.fetchone()[0]
            cursor.execute("INSERT INTO asientos_reserva (reserva_id, asiento_id) VALUES (%s, %s);", (reserva_id, asiento_id))
            cursor.execute("UPDATE asientos SET disponible = false WHERE id = %s;", (asiento_id,))
            conn.commit()
            with lock:
                resultados["exitosas"] += 1

        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Error con cliente {cliente_id}: {e}")
        with lock:
            resultados["fallidas"] += 1

def simular_hotspot(concurrentes, nivel_aislamiento, nombre_nivel):
    global resultados
    resultados = {"exitosas": 0, "fallidas": 0}
    hilos = []
    start = time.time()
    max_asiento = concurrentes 

    resetear_base(max_asiento)

    for _ in range(concurrentes):
        cliente_id = random.randint(1, 6)
        numero_asiento = random.randint(1, max_asiento)
        hilo = threading.Thread(target=reservar_asiento, args=(cliente_id, nivel_aislamiento, numero_asiento))
        hilos.append(hilo)
        hilo.start()

    for h in hilos:
        h.join()
    end = time.time()

    print(f"Nivel de aislamiento: {nombre_nivel}")
    print(f"Usuarios: {concurrentes}")
    print(f"Reservas exitosas: {resultados['exitosas']}")
    print(f"Reservas fallidas: {resultados['fallidas']}")
    print(f"Tiempo total: {(end - start) * 1000:.2f} ms \n")

if __name__ == "__main__":
    niveles = {
        "READ COMMITTED": 1,
        "REPEATABLE READ": 2,
        "SERIALIZABLE": 3
    }

    for nombre, nivel in niveles.items():
        for concurrentes in [5, 10, 20, 30]:
            simular_hotspot(concurrentes=concurrentes, nivel_aislamiento=nivel, nombre_nivel=nombre)