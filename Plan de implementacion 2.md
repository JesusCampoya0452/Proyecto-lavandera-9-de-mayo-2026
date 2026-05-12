Este es el **Plan Maestro de Implementación Definitivo y Ultra-Extendido**, diseñado para ser la fuente de verdad absoluta del proyecto. Está estructurado con un nivel de detalle técnico profundo para que **Antigravity** genere la lógica, la base de datos y la interfaz de tu App de Lavandería con precisión quirúrgica.

---

# 🚀 Plan Maestro de Implementación: "Lavandería Pro" (Estructura de Alto Nivel)

Este documento detalla la ingeniería detrás de la aplicación, eliminando por completo **Provider** y consolidando un ecosistema basado en **Riverpod**, **Clean Architecture** y **Relational Data Integrity**.

---

## 1. 🏗️ Arquitectura de Software: Clean Architecture + Feature-First

Para que la aplicación sea escalable y mantenible, dividiremos el código en **Features**. Cada funcionalidad es un módulo independiente que contiene tres capas bien definidas:

### A. Capa de Presentación (Presentation Layer)

* **Widgets:** Componentes visuales puros y atómicos.
* **Controllers (Riverpod Notifiers):** Aquí reside la lógica de la UI. Escuchan los cambios del usuario y se comunican con la capa de dominio. No contienen lógica de negocio compleja, solo gestionan el estado de la pantalla.

### B. Capa de Dominio (Domain Layer)

* **Entities:** Objetos de negocio puros (ej. `LaundryOrder`, `LaundryService`). Son inmutables.
* **Repositories (Interfaces):** Contratos que definen qué puede hacer la app, sin decir cómo se hace.
* **Use Cases:** Acciones específicas (ej. `CalculateTotalWithTax`, `ValidateCoupon`).

### C. Capa de Datos (Data Layer)

* **Mappers:** Convierten datos brutos (JSON de Firestore o filas de SQL) en Entidades de dominio.
* **Repositories (Implementations):** Aquí se decide si los datos vienen de la nube (Firebase) o de la base de datos local (SQLite).

---

## 2. 🏛️ Diseño de Base de Datos Profesional (DBA Vision)

El sistema requiere una **trazabilidad quirúrgica**. Cada movimiento de una prenda debe quedar registrado en un modelo relacional normalizado.

### Esquema Detallado de Tablas

1. **Catálogo:** `services` (precios, descripción) y `categories` (Ropa de Cama, Tintorería).
2. **Operación:** `orders` (registro maestro), `order_items` (desglose de piezas) y `order_status_history` (log cronológico para auditoría).
3. **Finanzas:** `payments` (id_orden, monto, método de pago, referencia de transacción).

---

## 3. 🚀 Gestión de Estado con Riverpod (Modern Way)

Sustituimos definitivamente `provider` por **Riverpod con Code Generation** para seguridad de tipos en tiempo de compilación.

* **`AuthNotifier`:** Gestiona el estado de autenticación. Si el usuario cierra sesión, todos los demás providers se reinician.
* **`CartProvider`:** Un `Notifier` especializado en cálculos. Maneja una lista de `CartItem` y expone el `totalAmount`.
* **`OrderTrackingProvider`:** Un `StreamProvider` suscrito a Firestore. Actualiza la App del cliente en tiempo real cuando el staff cambia el estado en el local.

---

## 4. 🎨 Diseño de Experiencia de Usuario (UI/UX)

Estética **"Fresh & Clean"**:

* **Paleta:** Azul Glaciar (#E1F5FE) para fondos, Azul Cobalto (#1976D2) para acciones primarias.
* **Pantalla de Tracking:** Implementación de un Stepper dinámico: *Recogido → En Lavado → Secado → Planchado → Listo*.

---

## 5. 🛠️ Pasos Detallados para la Implementación (Workflow de Ingeniería)

Para que Antigravity genere el código correctamente, seguiremos estos pasos secuenciales:

### Paso 1: Configuración del Core y Dependencias

* Inicializar el proyecto Flutter.
* Configurar el `pubspec.yaml` con: `flutter_riverpod`, `riverpod_annotation`, `freezed`, `go_router`, `cloud_firestore`, `sqflite`.
* Establecer la estructura de carpetas `lib/src/features/`.

### Paso 2: Implementación de la Capa de Datos (Data Layer)

* Crear los modelos de datos inmutables con **Freezed**.
* Configurar los `DataSources`: uno para **Firebase** (pedidos activos) y otro para **SQLite** (historial y caché).
* Escribir el script SQL DDL para la base de datos local.

### Paso 3: Lógica de Dominio y Casos de Uso

* Definir las entidades puras de Dart.
* Crear los repositorios abstractos (Interfaces).
* Implementar lógica de negocio: cálculo de impuestos, validación de horarios de recogida y reglas de descuento por volumen.

### Paso 4: Gestión de Estado con Riverpod Generator

* Generar los providers de autenticación.
* Crear el `CartNotifier` para manejar el estado complejo del carrito (añadir, quitar, incrementar cantidad).
* Implementar el `StreamProvider` para el seguimiento en tiempo real.

### Paso 5: Desarrollo de la UI Atómica

* Diseñar widgets reutilizables: `LaundryPriceTag`, `StatusBadge`, `OrderSummaryCard`.
* Construir la pantalla de catálogo con filtrado por categorías.
* Desarrollar la pantalla de "Checkout" con integración visual de pasarela de pago.

### Paso 6: Navegación y Guardias de Seguridad

* Configurar **GoRouter** con rutas para: `/login`, `/dashboard`, `/order-details/:id`, `/payment`.
* Implementar `redirect` para asegurar que usuarios no logueados siempre sean enviados a `/login`.

### Paso 7: Pruebas y Aseguramiento de Calidad (QA)

* Unit Testing de los UseCases (especialmente cálculos financieros).
* Widget Testing de los componentes críticos.
* Verificación de reglas de seguridad en Firestore.

---

## 📝 Prompt Definitivo para Antigravity (Copia y Pega)

Perfecto. He ajustado el prompt para **Antigravity** eliminando cualquier rastro de `Provider` y sustituyéndolo por un enfoque moderno basado en **Riverpod** con generación de código (`Riverpod Generator`), que es el estándar actual para proyectos de alto rendimiento en Flutter.

Aquí tienes el prompt definitivo para que lo copies y pegues:

---

### 🚀 Prompt para Antigravity: App "Lavandería Pro" (Full Riverpod & SQL)

**System Context:**

> "Actúa como un Arquitecto de Software experto en Flutter y DBA. El objetivo es generar el andamiaje técnico de una aplicación de lavandería profesional que utilice Riverpod para el estado y una estructura relacional para los datos."

**Prompt Principal:**

"Genera la estructura técnica y visual para una aplicación de lavandería en **Flutter** eliminando por completo el uso de Provider y utilizando **Riverpod (con riverpod_generator)** como única solución de gestión de estado.

**1. Arquitectura de Datos (Enfoque Relacional):**
Diseña un esquema de base de datos SQL normalizado y escalable que incluya las siguientes entidades con integridad referencial:

* **CLIENTE:** (id, nombre, email, direccion_entrega).
* **SERVICIO:** (id, nombre, precio_decimal, categoria_enum).
* **ORDEN:** (id, id_cliente, fecha_creacion, estado_actual_enum).
* **DETALLE_ORDEN:** (id, id_orden, id_servicio, cantidad, subtotal_decimal).
* **PAGO:** (id, id_orden, monto_decimal, metodo_pago_enum).
*(Genera el script SQL DDL compatible con MySQL/PostgreSQL usando tipos DECIMAL para montos monetarios).*

**2. Gestión de Estado con Riverpod:**

* Crea un `AsyncNotifierProvider` para gestionar el estado de las órdenes en tiempo real.
* Implementa un `StreamProvider` para escuchar los cambios de estado de la lavandería desde Firebase Firestore.
* Crea un `StateProvider` para el manejo del carrito de servicios antes de confirmar el pedido.
* Asegura que no exista ninguna dependencia de 'provider' en el archivo `pubspec.yaml` ni en los archivos `.dart`.

**3. Interfaz de Usuario (UI):**

* **Diseño:** Estilo minimalista con enfoque en accesibilidad.
* **Componentes:** Un 'ServiceSelector' con cards modernas, un 'OrderStepper' para visualizar el progreso del lavado y un 'PaymentSummary'.
* **Navegación:** Configura **GoRouter** para manejar rutas protegidas (Login/Dashboard).

**4. Entregables de Código:**

* Modelos de datos inmutables usando la sintaxis de **Freezed**.
* Estructura de carpetas bajo el patrón **Feature-First** (auth, services, orders, payment).
* Lógica de validación para formularios de recogida y entrega."

---

### 💡 Por qué este prompt es mejor:

1. **Eliminación estricta de Provider:** Al especificar `riverpod_generator`, obligas a la IA a usar la sintaxis más moderna de Riverpod (clases con la anotación `@riverpod`), evitando patrones obsoletos.
2. **Precisión Financiera:** Al insistir en `DECIMAL` y `monto_decimal`, evitas que Antigravity use `double`, lo que previene errores de precisión en los cobros de la lavandería.
3. **Clean Architecture:** Al pedir el patrón **Feature-First**, el código que genere será fácil de navegar y escalar si decides añadir funciones como "lavado de alfombras" o "suscripciones mensuales" después.
