-- Insertar tipo de evento
INSERT INTO tipo_eventos (nombre) VALUES ('Concierto');

-- Insertar primer evento
INSERT INTO eventos (nombre, tipo_id, fecha_evento)
VALUES ('Rock Fest 2025', 1, '2025-06-15 19:00:00');

-- Insertar segundo evento
INSERT INTO eventos (nombre, tipo_id, fecha_evento)
VALUES ('Tech Talk 2025', 1, '2025-07-20 18:00:00');

-- Clientes
INSERT INTO clientes (nombre, correo, direccion, telefono) VALUES
('Ana Gómez', 'ana@example.com', 'Zona 10, Ciudad de Guatemala', 12345678),
('Luis Pérez', 'luis@example.com', 'Zona 1, Ciudad de Guatemala', 87654321),
('María López', 'maria@example.com', 'Zona 5, Mixco', 55667788),
('Carlos Rivera', 'carlos@example.com', 'Zona 11, Ciudad de Guatemala', 99887766),
('Fernando Morales', 'fernando@example.com', 'Zona 16, Ciudad', 12312312),
('Sofía Estrada', 'sofia@example.com', 'Zona 18, Ciudad', 32132132);

-- Reservas para primer evento
INSERT INTO reservas (evento_id, cliente_id) VALUES
(1, 1), 
(1, 2), 
(1, 3); 

-- Reservas para segundo evento
INSERT INTO reservas (evento_id, cliente_id) VALUES
(2, 4), -- Carlos
(2, 5); -- Fernando

-- Asignar asientos para primer evento
INSERT INTO asientos_reserva (reserva_id, asiento_id) VALUES
(1, 1),
(1, 2);


INSERT INTO asientos_reserva (reserva_id, asiento_id) VALUES
(2, 3),
(2, 4);


INSERT INTO asientos_reserva (reserva_id, asiento_id) VALUES
(3, 5);

-- Asignar asientos para segundo evento 
INSERT INTO asientos_reserva (reserva_id, asiento_id) VALUES
(4, 21);


INSERT INTO asientos_reserva (reserva_id, asiento_id) VALUES
(5, 22);

-- Marcar asientos como no disponibles
UPDATE asientos SET disponible = false WHERE id IN (1, 2, 3, 4, 5, 21, 22);

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

-- Crear trigger crear asientos
CREATE TRIGGER crear_asientos_trigger
AFTER INSERT ON eventos
FOR EACH ROW
EXECUTE FUNCTION crear_asientos_por_evento();
