Entendido. Vamos a expandir el plan de implementación para la aplicación de **Lavandería**, profundizando en la arquitectura técnica, la lógica de negocio y el modelado de datos detallado, integrando la visión de un Administrador de Base de Datos para asegurar que el sistema sea profesional y escalable.

---

# 📋 Plan de Implementación Extenso: App "Lavandería Pro" (Flutter + Firebase)

## 1. 🛠️ Ecosistema de Desarrollo y Herramientas

Para garantizar un rendimiento óptimo y un mantenimiento sencillo, se divide el stack en tres capas:

| Categoría | Herramienta | Justificación |
| --- | --- | --- |
| **Frontend** | **Flutter SDK** | Desarrollo ágil para Android, iOS y Web con un solo código base. |
| **Backend (BaaS)** | **Firebase** | Gestión de autenticación, base de datos NoSQL para tiempo real y notificaciones push. |
| **Relational DB** | **MySQL / SQLite** | Gestión estructurada para reportes financieros y auditoría de inventario. |
| **IDE** | **VS Code** | Integración nativa con Dart DevTools y Firebase CLI. |
| **Procesamiento** | **Cloud Functions** | Lógica de servidor para procesos sensibles (pagos, cambio de estados masivos). |

---

## 2. 🏛️ Arquitectura de Datos (Enfoque DBA)

El éxito de una lavandería depende del control exacto de las prendas. Un error en la base de datos significa una prenda perdida.

### 2.1. Modelo de Entidades y Atributos

He diseñado el esquema pensando en la **normalización** para evitar redundancias y asegurar la integridad:

* **CLIENTE:** Almacena datos de contacto y preferencias de lavado (ej. suavizante específico).
* **SERVICIO:** Catálogo dinámico. Permite diferenciar entre "Lavado por Carga" y "Tintorería por pieza".
* **ORDEN:** El corazón del sistema. Registra tiempos de entrada, tiempos prometidos y tiempos de entrega real.
* **DETALLE_ORDEN:** Tabla de quiebre para permitir que una sola orden tenga múltiples servicios (ej. 3 camisas planchadas + 1 edredón lavado).
* **PAGO:** Registro contable vinculado a la orden.

### 2.2. Tabla Detallada de Entidades

| Entidad | Atributo | Tipo de Dato | Descripción |
| --- | --- | --- | --- |
| **CLIENTE** | `id_cliente` | `INT (PK)` | Identificador único. |
|  | `nombre` | `VARCHAR(100)` | Nombre completo. |
|  | `email` | `VARCHAR(100)` | Único para login. |
|  | `direccion` | `TEXT` | Para recolección (Delivery). |
| **SERVICIO** | `id_servicio` | `INT (PK)` | Identificador de servicio. |
|  | `nombre` | `VARCHAR(100)` | Ej: "Lavado Carga 8kg". |
|  | `precio_u` | `DECIMAL(10,2)` | Evita errores de punto flotante. |
| **ORDEN** | `id_orden` | `INT (PK)` | Número de ticket. |
|  | `id_cliente` | `INT (FK)` | Relación con el usuario. |
|  | `estado` | `ENUM` | Pendiente, Lavando, Listo, Entregado. |
|  | `total` | `DECIMAL(10,2)` | Suma calculada de los detalles. |

---

## 3. 🚀 Script Estructural SQL (`bd_lavanderia_completa.sql`)

Este script incluye las relaciones de cardinalidad (uno a muchos) y las restricciones de integridad necesarias.

```sql
CREATE DATABASE IF NOT EXISTS lavanderia_db;
USE lavanderia_db;

-- Tabla de Servicios (Catálogo)
CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_unitario DECIMAL(10,2) NOT NULL,
    unidad_medida ENUM('Kg', 'Pieza', 'Par') DEFAULT 'Pieza'
) ENGINE=InnoDB;

-- Tabla de Clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tabla de Órdenes (Encabezado)
CREATE TABLE ordenes (
    id_orden INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha_ingreso DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_entrega_estimada DATETIME,
    estado_orden ENUM('Recibido', 'En Lavado', 'Secado/Planchado', 'Listo', 'Entregado') DEFAULT 'Recibido',
    metodo_entrega ENUM('Tienda', 'Domicilio') DEFAULT 'Tienda',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla Detalle de Orden (Cuerpo)
CREATE TABLE detalle_orden (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_orden INT,
    id_servicio INT,
    cantidad INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_orden) REFERENCES ordenes(id_orden) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
) ENGINE=InnoDB;

```

---

## 4. 🎨 Estrategia de UI/UX (Flutter)

La interfaz debe ser "limpia" (literalmente). Se proponen los siguientes flujos:

1. **Dashboard del Cliente:** Un resumen visual con el estado de su orden actual mediante un **Stepper Progress Bar**.
2. **Catálogo Visual:** Uso de tarjetas (`Cards`) con iconos claros para cada tipo de prenda (camisas, pantalones, ropa de cama).
3. **Carrito de Servicios:** Resumen dinámico donde se puede ajustar la cantidad de piezas o kilos antes de confirmar.

---

## 5. 📦 Gestión de Dependencias Críticas

* **`firebase_auth`**: Manejo de identidad seguro.
* **`cloud_firestore`**: Para que el cliente reciba una actualización instantánea cuando su ropa pase de "En Lavado" a "Listo".
* **`flutter_local_notifications`**: Avisos críticos (ej: "Tu repartidor está en camino").
* **`sqflite`**: Para almacenar el catálogo de precios localmente y que la app funcione sin internet en la toma de pedidos.
* **`pdf`**: Generación automática de tickets o facturas digitales desde la app.

---

## 6. 📅 Plan de Sprints (Cronograma Estimado)

### Semana 1: Backend y Base de Datos

* Configuración de Firebase Project.
* Implementación del modelo relacional en la nube.
* Desarrollo de las API de conexión (Repositories en Flutter).

### Semana 2: Autenticación y Perfiles

* Login con Email/Google.
* Gestión de direcciones de envío (Integración con Google Maps API).

### Semana 3: El "Corazón" de la App

* Pantalla de selección de servicios.
* Lógica del carrito de compras y cálculo de impuestos/totales.
* Creación del registro de la orden en Firestore.

### Semana 4: Seguimiento y Cierre

* Implementación de la vista de seguimiento (Tracking).
* Pasarela de pagos (Stripe o Mercado Pago).
* Generación de comprobantes en PDF.

---

## 7. ✅ Recomendaciones del Experto

* **Seguridad de Datos:** Las reglas de Firebase deben ser estrictas: `allow read: if request.auth.uid == resource.data.userId`.
* **Mantenimiento:** Implementar un log de errores con **Firebase Crashlytics** para detectar si algún cálculo de precio falla en dispositivos específicos.
* **Escalabilidad:** El uso de `DECIMAL(10,2)` en la base de datos es innegociable para evitar centavos perdidos que, a gran escala, afectan la contabilidad.
