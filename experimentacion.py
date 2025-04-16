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