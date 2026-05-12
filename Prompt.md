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
