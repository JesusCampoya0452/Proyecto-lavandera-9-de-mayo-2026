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

> **"Genera el sistema completo para la aplicación 'Lavandería Pro' utilizando Flutter. Sigue estrictamente estas especificaciones técnicas:**
> **1. GESTIÓN DE ESTADO Y ARQUITECTURA:**
> * **PROHIBIDO USAR PROVIDER.** Implementa **Riverpod** utilizando `riverpod_generator`.
> * Aplica **Clean Architecture** con estructura de carpetas **Feature-First**.
> * Utiliza **Freezed** para todos los modelos de datos y estados.
> 
> 
> **2. MODELADO DE DATOS:**
> * Genera un script SQL DDL normalizado (Tablas: Clientes, Servicios, Órdenes, Detalle, Pagos).
> * Implementa sincronización: Pedidos activos en **Firestore**, historial en **SQLite**.
> 
> 
> **3. FUNCIONALIDADES ESPECÍFICAS:**
> * **Cart Logic:** Notifier que gestione ítems, calcule IVA y costo de envío.
> * **Order Tracking:** Pantalla con Stepper visual consumiendo un Stream en tiempo real.
> * **Auth:** Login con Firebase Auth y persistencia con GoRouter.
> 
> 
> **4. INTERFAZ (UI/UX):**
> * Estilo: Limpio, minimalista, paleta azul y blanco.
> * Genera componentes: `LaundryServiceCard`, `OrderStepIndicator`, `PriceSummary`.
> 
> 
> **5. ENTREGABLES:**
> * Código fuente completo por capas.
> * Script SQL DDL.
> * Archivo pubspec.yaml completo."
> 
>
