-- ============================================================
--  BASE DE DATOS: SISTEMA DE GESTIÓN DE LAVANDERÍA
--  Archivo  : bdlavanderia.sql
--  Motor    : MySQL 8.0+
--  Creado   : 2026-05-12
-- ============================================================

DROP DATABASE IF EXISTS bdlavanderia;
CREATE DATABASE bdlavanderia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE bdlavanderia;

-- ============================================================
--  1. SUCURSAL
-- ============================================================
CREATE TABLE sucursal (
  id_sucursal   INT            NOT NULL AUTO_INCREMENT,
  nombre        VARCHAR(80)    NOT NULL,
  direccion     VARCHAR(200)   NOT NULL,
  telefono      VARCHAR(15)        NULL,
  activa        BOOLEAN        NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_sucursal PRIMARY KEY (id_sucursal)
) ENGINE=InnoDB;

-- ============================================================
--  2. EMPLEADO
-- ============================================================
CREATE TABLE empleado (
  id_empleado   INT            NOT NULL AUTO_INCREMENT,
  id_sucursal   INT            NOT NULL,
  nombre        VARCHAR(100)   NOT NULL,
  puesto        VARCHAR(60)    NOT NULL,
  telefono      VARCHAR(15)        NULL,
  fecha_alta    DATE           NOT NULL,
  activo        BOOLEAN        NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_empleado    PRIMARY KEY (id_empleado),
  CONSTRAINT fk_emp_suc     FOREIGN KEY (id_sucursal)
    REFERENCES sucursal(id_sucursal)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_empleado_sucursal ON empleado (id_sucursal);

-- ============================================================
--  3. CLIENTE
-- ============================================================
CREATE TABLE cliente (
  id_cliente      INT            NOT NULL AUTO_INCREMENT,
  nombre          VARCHAR(100)   NOT NULL,
  telefono        VARCHAR(15)        NULL,
  email           VARCHAR(120)       NULL,
  direccion       VARCHAR(200)       NULL,
  fecha_registro  DATE           NOT NULL DEFAULT (CURRENT_DATE),
  activo          BOOLEAN        NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_cliente PRIMARY KEY (id_cliente)
) ENGINE=InnoDB;

CREATE INDEX idx_cliente_telefono ON cliente (telefono);
CREATE INDEX idx_cliente_email    ON cliente (email);

-- ============================================================
--  4. SERVICIO
-- ============================================================
CREATE TABLE servicio (
  id_servicio          INT            NOT NULL AUTO_INCREMENT,
  nombre               VARCHAR(80)    NOT NULL,
  descripcion          TEXT               NULL,
  precio_base          DECIMAL(10,2)  NOT NULL,
  tiempo_estimado_hrs  SMALLINT       NOT NULL DEFAULT 24,
  activo               BOOLEAN        NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_servicio PRIMARY KEY (id_servicio)
) ENGINE=InnoDB;

-- ============================================================
--  5. PROVEEDOR
-- ============================================================
CREATE TABLE proveedor (
  id_proveedor  INT            NOT NULL AUTO_INCREMENT,
  nombre        VARCHAR(100)   NOT NULL,
  contacto      VARCHAR(100)       NULL,
  telefono      VARCHAR(15)        NULL,
  email         VARCHAR(120)       NULL,
  CONSTRAINT pk_proveedor PRIMARY KEY (id_proveedor)
) ENGINE=InnoDB;

-- ============================================================
--  6. INSUMO
-- ============================================================
CREATE TABLE insumo (
  id_insumo       INT            NOT NULL AUTO_INCREMENT,
  id_proveedor    INT            NOT NULL,
  nombre          VARCHAR(100)   NOT NULL,
  unidad          VARCHAR(20)    NOT NULL,
  stock_actual    DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
  stock_minimo    DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
  costo_unitario  DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
  CONSTRAINT pk_insumo      PRIMARY KEY (id_insumo),
  CONSTRAINT fk_ins_prov    FOREIGN KEY (id_proveedor)
    REFERENCES proveedor(id_proveedor)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_insumo_proveedor ON insumo (id_proveedor);

-- ============================================================
--  7. ORDEN
-- ============================================================
CREATE TABLE orden (
  id_orden             INT            NOT NULL AUTO_INCREMENT,
  id_cliente           INT            NOT NULL,
  id_empleado          INT            NOT NULL,
  id_sucursal          INT            NOT NULL,
  fecha_ingreso        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fecha_entrega_est    DATETIME           NULL,
  fecha_entrega_real   DATETIME           NULL,
  estado               ENUM(
                         'recibido',
                         'en_proceso',
                         'listo',
                         'entregado',
                         'cancelado'
                       )              NOT NULL DEFAULT 'recibido',
  notas                TEXT               NULL,
  CONSTRAINT pk_orden       PRIMARY KEY (id_orden),
  CONSTRAINT fk_ord_cli     FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_ord_emp     FOREIGN KEY (id_empleado)
    REFERENCES empleado(id_empleado)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_ord_suc     FOREIGN KEY (id_sucursal)
    REFERENCES sucursal(id_sucursal)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_orden_cliente   ON orden (id_cliente);
CREATE INDEX idx_orden_estado    ON orden (estado);
CREATE INDEX idx_orden_ingreso   ON orden (fecha_ingreso);

-- ============================================================
--  8. PRENDA_ORDEN  (detalle de la orden)
-- ============================================================
CREATE TABLE prenda_orden (
  id_detalle        INT            NOT NULL AUTO_INCREMENT,
  id_orden          INT            NOT NULL,
  id_servicio       INT            NOT NULL,
  id_insumo         INT                NULL,
  descripcion_prenda VARCHAR(150)  NOT NULL,
  color             VARCHAR(50)        NULL,
  cantidad          DECIMAL(6,2)   NOT NULL DEFAULT 1.00,
  precio_unitario   DECIMAL(10,2)  NOT NULL,
  observaciones     TEXT               NULL,
  CONSTRAINT pk_prenda_orden  PRIMARY KEY (id_detalle),
  CONSTRAINT fk_pd_orden      FOREIGN KEY (id_orden)
    REFERENCES orden(id_orden)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pd_servicio   FOREIGN KEY (id_servicio)
    REFERENCES servicio(id_servicio)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pd_insumo     FOREIGN KEY (id_insumo)
    REFERENCES insumo(id_insumo)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX idx_pd_orden     ON prenda_orden (id_orden);
CREATE INDEX idx_pd_servicio  ON prenda_orden (id_servicio);

-- ============================================================
--  9. PAGO
-- ============================================================
CREATE TABLE pago (
  id_pago       INT            NOT NULL AUTO_INCREMENT,
  id_orden      INT            NOT NULL,
  monto_total   DECIMAL(10,2)  NOT NULL,
  descuento     DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
  monto_pagado  DECIMAL(10,2)  NOT NULL,
  metodo_pago   ENUM(
                  'efectivo',
                  'tarjeta',
                  'transferencia',
                  'otro'
                )              NOT NULL DEFAULT 'efectivo',
  fecha_pago    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_pago      PRIMARY KEY (id_pago),
  CONSTRAINT fk_pago_ord  FOREIGN KEY (id_orden)
    REFERENCES orden(id_orden)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_pago_orden ON pago (id_orden);

-- ============================================================
--  10. MOVIMIENTO_INSUMO  (entradas / salidas de inventario)
-- ============================================================
CREATE TABLE movimiento_insumo (
  id_movimiento  INT            NOT NULL AUTO_INCREMENT,
  id_insumo      INT            NOT NULL,
  id_empleado    INT            NOT NULL,
  tipo           ENUM(
                   'entrada',
                   'salida',
                   'ajuste'
                 )              NOT NULL,
  cantidad       DECIMAL(10,2)  NOT NULL,
  fecha          DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  referencia     VARCHAR(120)       NULL COMMENT 'Número de factura, orden, etc.',
  notas          TEXT               NULL,
  CONSTRAINT pk_movimiento     PRIMARY KEY (id_movimiento),
  CONSTRAINT fk_mov_insumo     FOREIGN KEY (id_insumo)
    REFERENCES insumo(id_insumo)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_mov_empleado   FOREIGN KEY (id_empleado)
    REFERENCES empleado(id_empleado)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_mov_insumo  ON movimiento_insumo (id_insumo);
CREATE INDEX idx_mov_fecha   ON movimiento_insumo (fecha);

-- ============================================================
--  DATOS DE PRUEBA
-- ============================================================

INSERT INTO sucursal (nombre, direccion, telefono) VALUES
  ('Sucursal Centro',  'Av. Juárez 100, Col. Centro',      '656-100-0001'),
  ('Sucursal Norte',   'Blvd. Independencia 450, Col. Las Torres', '656-100-0002');

INSERT INTO proveedor (nombre, contacto, telefono, email) VALUES
  ('Química del Norte S.A.',  'Carlos Medina',  '656-200-0010', 'ventas@quimicanorte.mx'),
  ('Distribuidora Limpieza',  'Laura Ríos',     '656-200-0011', 'pedidos@distrilimpieza.mx');

INSERT INTO insumo (id_proveedor, nombre, unidad, stock_actual, stock_minimo, costo_unitario) VALUES
  (1, 'Detergente industrial', 'litro', 200.00, 50.00, 12.50),
  (1, 'Suavizante de telas',   'litro',  80.00, 20.00,  9.00),
  (2, 'Bolsas plásticas 60x90','pieza', 500.00, 100.00,  0.80),
  (2, 'Ganchos metálicos',     'pieza', 300.00,  50.00,  2.50);

INSERT INTO empleado (id_sucursal, nombre, puesto, telefono, fecha_alta) VALUES
  (1, 'María González',  'Cajera',     '656-301-0001', '2023-01-15'),
  (1, 'Pedro Ramírez',   'Lavandero',  '656-301-0002', '2023-02-01'),
  (2, 'Ana Flores',      'Cajera',     '656-301-0003', '2023-03-10'),
  (2, 'Luis Morales',    'Planchador', '656-301-0004', '2024-01-05');

INSERT INTO cliente (nombre, telefono, email, direccion, fecha_registro) VALUES
  ('Juan Carlos Torres',  '656-401-1001', 'jctorres@mail.com',  'Calle Roble 22',   '2024-03-01'),
  ('Sofía Martínez',      '656-401-1002', 'sofiamtz@mail.com',  'Av. Palmas 88',    '2024-05-10'),
  ('Roberto Leal',        '656-401-1003',  NULL,                'Calle Pino 5',     '2025-01-20');

INSERT INTO servicio (nombre, descripcion, precio_base, tiempo_estimado_hrs) VALUES
  ('Lavado express',     'Lavado rápido en lavadora industrial',       25.00,  4),
  ('Lavado normal',      'Lavado estándar con suavizante',             18.00, 24),
  ('Planchado',          'Planchado a vapor por pieza',                10.00, 12),
  ('Tintorería',         'Limpieza en seco para prendas delicadas',    55.00, 48),
  ('Lavado + planchado', 'Servicio completo lavado y planchado',       30.00, 36);

INSERT INTO orden (id_cliente, id_empleado, id_sucursal, fecha_ingreso, fecha_entrega_est, estado, notas) VALUES
  (1, 1, 1, '2026-05-10 09:00:00', '2026-05-12 10:00:00', 'entregado',  'Cliente frecuente'),
  (2, 1, 1, '2026-05-11 11:30:00', '2026-05-13 11:00:00', 'en_proceso', NULL),
  (3, 3, 2, '2026-05-12 08:45:00', '2026-05-14 09:00:00', 'recibido',   'Mancha difícil en camisa blanca');

INSERT INTO prenda_orden (id_orden, id_servicio, id_insumo, descripcion_prenda, color, cantidad, precio_unitario, observaciones) VALUES
  (1, 1, 1, 'Camisa de vestir',  'Blanco',  3.00, 25.00, NULL),
  (1, 3, NULL,'Pantalón de vestir','Negro', 2.00, 10.00, NULL),
  (2, 4, NULL,'Traje sastre',    'Gris',    1.00, 55.00, 'Revisar solapa'),
  (2, 2, 2, 'Ropa de cama',     'Varios',  5.00, 18.00, NULL),
  (3, 5, 1, 'Camisa casual',    'Blanco',  2.00, 30.00, 'Mancha de café en cuello');

INSERT INTO pago (id_orden, monto_total, descuento, monto_pagado, metodo_pago) VALUES
  (1, 95.00, 0.00,  95.00, 'efectivo'),
  (2, 145.00, 10.00, 135.00, 'tarjeta');

INSERT INTO movimiento_insumo (id_insumo, id_empleado, tipo, cantidad, referencia, notas) VALUES
  (1, 2, 'entrada', 100.00, 'FAC-2026-001', 'Compra mensual detergente'),
  (1, 2, 'salida',    3.50, 'ORD-000001',   'Consumo orden #1'),
  (2, 2, 'salida',    2.00, 'ORD-000002',   'Consumo orden #2');

-- ============================================================
--  VISTAS ÚTILES
-- ============================================================

CREATE OR REPLACE VIEW v_ordenes_detalle AS
SELECT
  o.id_orden,
  o.fecha_ingreso,
  o.estado,
  o.fecha_entrega_est,
  c.nombre          AS cliente,
  c.telefono        AS tel_cliente,
  e.nombre          AS empleado,
  s.nombre          AS sucursal,
  COUNT(pd.id_detalle) AS total_prendas,
  SUM(pd.cantidad * pd.precio_unitario) AS subtotal
FROM orden o
JOIN cliente    c  ON c.id_cliente  = o.id_cliente
JOIN empleado   e  ON e.id_empleado = o.id_empleado
JOIN sucursal   s  ON s.id_sucursal = o.id_sucursal
JOIN prenda_orden pd ON pd.id_orden = o.id_orden
GROUP BY o.id_orden, o.fecha_ingreso, o.estado, o.fecha_entrega_est,
         c.nombre, c.telefono, e.nombre, s.nombre;

CREATE OR REPLACE VIEW v_inventario_alerta AS
SELECT
  i.id_insumo,
  i.nombre,
  i.unidad,
  i.stock_actual,
  i.stock_minimo,
  p.nombre AS proveedor,
  p.telefono AS tel_proveedor
FROM insumo i
JOIN proveedor p ON p.id_proveedor = i.id_proveedor
WHERE i.stock_actual <= i.stock_minimo;

-- ============================================================
--  FIN DEL SCRIPT
-- ============================================================
