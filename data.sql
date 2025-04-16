-- Crear función para generar 20 asientos al insertar un evento
CREATE OR REPLACE FUNCTION crear_asientos_para_evento()
RETURNS trigger AS $$
BEGIN
  FOR i IN 1..20 LOOP
    INSERT INTO asientos (evento_id, numero, disponible)
    VALUES (NEW.id, i, true);
  END LOOP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger para generar asientos automáticamente al insertar un evento
CREATE TRIGGER crear_asientos_trigger
AFTER INSERT ON eventos
FOR EACH ROW
EXECUTE FUNCTION crear_asientos_para_evento();

-- Insertar tipo de evento
INSERT INTO tipo_eventos (nombre) VALUES ('Concierto');

-- Insertar eventos (tipo_id = 1 porque es el que acabamos de insertar)
INSERT INTO eventos (nombre, tipo_id, fecha_evento)
VALUES 
('Rock Fest 2025', 1, '2025-06-15 19:00:00'),
('Tech Talk 2025', 1, '2025-07-20 18:00:00')
RETURNING id;

-- Guardamos los IDs de eventos generados para usarlos luego
-- (esto debes hacerlo en un script controlado, por ejemplo en un lenguaje como Python o en PgAdmin con variables)

-- Insertar clientes
INSERT INTO clientes (nombre, correo, direccion, telefono) VALUES
('Ana Gómez', 'ana@example.com', 'Zona 10, Ciudad de Guatemala', 12345678),
('Luis Pérez', 'luis@example.com', 'Zona 1, Ciudad de Guatemala', 87654321),
('María López', 'maria@example.com', 'Zona 5, Mixco', 55667788),
('Carlos Rivera', 'carlos@example.com', 'Zona 11, Ciudad de Guatemala', 99887766),
('Fernando Morales', 'fernando@example.com', 'Zona 16, Ciudad', 12312312),
('Sofía Estrada', 'sofia@example.com', 'Zona 18, Ciudad', 32132132);

-- Insertar reservas (usamos los IDs conocidos o capturados previamente)
-- Suponiendo que Rock Fest tiene id=1 y Tech Talk tiene id=2

-- Reservas para Rock Fest
INSERT INTO reservas (evento_id, cliente_id) VALUES
(1, 1), 
(1, 2), 
(1, 3); 

-- Reservas para Tech Talk
INSERT INTO reservas (evento_id, cliente_id) VALUES
(2, 4),
(2, 5); 

-- Insertar asientos_reserva (usando asientos generados automáticamente por el trigger)
-- Suponiendo que asientos del evento 1 van del 1 al 20
-- Y del evento 2 del 21 al 40

-- Asignar asientos para primer evento
INSERT INTO asientos_reserva (reserva_id, asiento_id) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5);

-- Asignar asientos para segundo evento 
INSERT INTO asientos_reserva (reserva_id, asiento_id) VALUES
(4, 21),
(5, 22);

-- Marcar asientos como no disponibles
UPDATE asientos SET disponible = false WHERE id IN (1, 2, 3, 4, 5, 21, 22);
