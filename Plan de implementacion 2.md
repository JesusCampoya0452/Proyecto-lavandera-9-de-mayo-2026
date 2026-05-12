Perfecto, eliminamos **Provider** por completo. Para una aplicación de este tipo, la recomendación técnica estándar en el ecosistema actual de Flutter es utilizar **Riverpod** o **Bloc/Cubit**, ya que ofrecen un manejo de estado más robusto, seguro y fácil de testear.

Aquí tienes el plan de implementación actualizado y extendido, enfocado exclusivamente en **Lavandería** y optimizado para una arquitectura moderna.

---

# 📋 Plan de Implementación Extenso: App "Lavandería Pro" (Flutter + Firebase)

## 1. 🛠️ Ecosistema y Stack Tecnológico

| Categoría | Herramienta | Propósito |
| --- | --- | --- |
| **Framework** | Flutter SDK | Desarrollo multiplataforma. |
| **Estado** | **Riverpod** | Gestión de estado reactiva, segura y sin contexto. |
| **Backend** | Firebase | Auth, Firestore (NoSQL) y Cloud Functions. |
| **Base de Datos** | SQL (MySQL/SQLite) | Reportes financieros y estructura relacional detallada. |
| **Navegación** | GoRouter | Enrutamiento declarativo y protección de rutas. |

---

## 2. 🏛️ Arquitectura de Base de Datos (DBA Design)

El diseño relacional es fundamental para la integridad de los pedidos. Evitaremos el uso de tipos de datos imprecisos para los costos.

### 2.1. Entidades y Atributos

* **CLIENTE:** Datos de perfil y geolocalización para entregas.
* **SERVICIO:** Catálogo de servicios (Lavado, Secado, Planchado, Tintorería).
* **ORDEN:** La cabecera del pedido que rastrea el ciclo de vida.
* **DETALLE_ORDEN:** Desglose de piezas y servicios aplicados a cada una.
* **PAGO:** Registro de transacciones financieras.

### 2.2. Tablas del Sistema

| Tabla | Atributos | Tipo de Dato |
| --- | --- | --- |
| **CLIENTE** | `id_cliente (PK)`, `nombre`, `email`, `telefono` | INT, VARCHAR, VARCHAR, VARCHAR |
| **SERVICIO** | `id_servicio (PK)`, `nombre`, `precio_unitario` | INT, VARCHAR, DECIMAL(10,2) |
| **ORDEN** | `id_orden (PK)`, `id_cliente (FK)`, `estado`, `total` | INT, INT, ENUM, DECIMAL(10,2) |
| **PAGO** | `id_pago (PK)`, `id_orden (FK)`, `monto`, `metodo` | INT, INT, DECIMAL(10,2), ENUM |

---

## 3. 🚀 Script SQL de Estructura (`bd_lavanderia.sql`)

Este script asegura que la base de datos sea relacionalmente íntegra.

```sql
CREATE DATABASE IF NOT EXISTS lavanderia_pro;
USE lavanderia_pro;

-- Servicios disponibles
CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    categoria ENUM('Lavado', 'Tintorería', 'Planchado', 'Otros')
) ENGINE=InnoDB;

-- Órdenes de trabajo
CREATE TABLE ordenes (
    id_orden INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente', 'Lavando', 'Listo para Entrega', 'Entregado') DEFAULT 'Pendiente',
    total_pagar DECIMAL(10,2) NOT NULL,
    INDEX (id_cliente)
) ENGINE=InnoDB;

-- Detalle por prenda/servicio
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

## 4. 📐 Arquitectura del Software (Flutter)

Para escalar sin errores, utilizaremos **Clean Architecture** organizada por **Features**.

* **Data Layer:** Repositorios y fuentes de datos (Firebase/SQL).
* **Domain Layer:** Entidades de negocio y casos de uso (Usecases).
* **Presentation Layer:** Widgets de Flutter y **Providers de Riverpod**.

**Estructura de carpetas:**

```text
lib/
├── src/
│   ├── features/
│   │   ├── auth/          # Login/Registro
│   │   ├── catalog/       # Selección de servicios
│   │   ├── orders/        # Seguimiento y carrito
│   │   └── payments/      # Pasarela de pagos
│   ├── core/              # Temas, Router, Errores
│   └── shared/            # Widgets comunes
└── main.dart

```

---

## 5. 📦 Dependencias Seleccionadas (Sin Provider)

* **`flutter_riverpod`**: Gestión de estado global.
* **`riverpod_annotation`**: Generación de código para estados más limpios.
* **`cloud_firestore`**: Base de datos en tiempo real para estados de pedidos.
* **`firebase_auth`**: Seguridad y perfiles.
* **`sqflite`**: Base de datos relacional local.
* **`go_router`**: Navegación avanzada.
* **`freezed_annotation`**: Modelos de datos inmutables.

---

## 6. ✅ Recomendaciones de Implementación

* **Sincronización:** Usa Firestore para el rastreo en vivo de la ropa y una base de datos SQL para los cierres de caja y auditoría.
* **Precios:** Siempre usa `Decimal` o convierte a centavos (`int`) en el código para evitar los errores de redondeo de los `double`.
* **UX:** Implementa un sistema de "historial de fotos" en el detalle de la orden para que el cliente vea el estado en que se recibió su prenda.

---

## 7. 🤖 Prompt para Antigravity (Versión Riverpod)

"Genera el código base para una App de Lavandería en Flutter utilizando **Riverpod** para la gestión de estado.

**Requerimientos:**

1. **Modelos:** Crea clases inmutables para 'Cliente', 'Orden' y 'Servicio'.
2. **Estado:** Implementa un `AsyncNotifier` de Riverpod para manejar el flujo de una orden (Desde selección de servicios hasta pago).
3. **UI:** Diseña una pantalla de tracking con un Stepper que consuma un `StreamProvider` de Firebase Firestore.
4. **Base de Datos:** Proporciona un script SQL compatible con MySQL que incluya tablas normalizadas para Clientes, Servicios, Órdenes, Detalle_Orden y Pagos.
5. **Arquitectura:** Sigue el patrón Feature-First. No utilices Provider, utiliza Riverpod con generación de código."
