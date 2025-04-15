DROP Database if EXISTS eventos;

CREATE Database eventos;

-- Crear tabla clientes.
CREATE TABLE clientes (
	id serial primary key,
	nombre varchar(255) not null,
	correo varchar(255) unique not null,
	direccion text,
	telefono int
);

-- Crear tabla tipo_eventos
CREATE TABLE tipo_eventos (
	id serial primary key,
	nombre varchar(100) not null
);

-- Crear tabla eventos
CREATE TABLE eventos (
	id serial primary key,
	nombre varchar(100) not null,
	tipo_id int not null,
	fecha_evento timestamp,
	Foreign key (tipo_id) references tipo_eventos(id) ON delete Cascade
);

-- Crear tabla asientos
CREATE TABLE asientos (
	id serial primary key,
	evento_id int not null,
	numero int not null,
	disponible boolean default true,
	Foreign key (evento_id) references eventos(id) ON delete cascade
);

-- Crear tabla reservas
CREATE TABLE reservas (
	id serial primary key,
	evento_id int not null,
	cliente_id int not null,
	Foreign key (evento_id) references eventos(id) On delete cascade,
	Foreign key (cliente_id) references clientes(id) On delete cascade
);

-- Crear tabla intermedia asientos_reserva
CREATE TABLE asientos_reserva (
	id serial primary key,
	reserva_id int not null,
	asiento_id int not null,
	Foreign key (reserva_id) references reservas(id) On delete cascade,
	Foreign key (asiento_id) references asientos(id) On delete cascade
);