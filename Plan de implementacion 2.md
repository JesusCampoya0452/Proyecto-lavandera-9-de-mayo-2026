Este es el **Plan Maestro de Implementación de Ingeniería de Software: Versión Omni-Canal Ultra-Extendida**.

He expandido cada sección para cubrir no solo el "qué" y el "cómo", sino el "porqué" de cada decisión arquitectónica, centrándome exclusivamente en el ecosistema **Firebase** y el diseño de la **Plataforma Web Administrativa**, eliminando cualquier rastro de SQL y manteniendo una estructura de carpetas industrial.

---

## 🏗️ 1. Filosofía de Arquitectura: "The Firebase Reactive Engine"

La aplicación no se comporta como una web tradicional de "petición y respuesta". Se basa en **Streams**. Esto significa que la base de datos "empuja" la información a los dispositivos (móvil y web) en milisegundos sin que el usuario tenga que refrescar.

### Capas de Lógica en la Nube:

* **Capa de Identidad (Auth):** Manejo de tokens JWT automáticos por Firebase.
* **Capa de Persistencia (Firestore):** Base de datos documental con consistencia eventual.
* **Capa de Cómputo (Cloud Functions):** Procesamiento de lógica pesada fuera del dispositivo para ahorrar batería y datos al cliente.
* **Capa de Activos (Storage):** Almacenamiento optimizado para imágenes de alta resolución de prendas para control de calidad.

---

## 📂 2. Estructura de Carpetas: "Feature-First Industrial"

Esta organización garantiza que el código sea modular. Si el módulo de "Pagos" falla, el resto de la app permanece intacta.

```text
lib/
├── main.dart                 # Configuración de Firebase Core y Crashlytics
├── app.dart                  # Root Widget, Configuración de Temas y GoRouter
│
├── src/
│   ├── core/                 # INFRAESTRUCTURA TRANSVERSAL
│   │   ├── common_widgets/   # Botones, campos de texto y esqueletos de carga (Shimmers)
│   │   ├── constants/        # IDs de Firebase, nombres de colecciones y estilos
│   │   ├── theme/            # Design System: Colores, Tipografías y Sombras
│   │   └── utils/            # Helpers para manejo de fechas, divisas y geolocalización
│   │
│   ├── features/             # UNIDADES DE NEGOCIO (Micro-Frontends)
│   │   ├── auth/             # Registro, Login, Recuperación y Perfil
│   │   │   ├── data/         # Repositorios que envuelven FirebaseAuth
│   │   │   ├── domain/       # Entidades AppUser y sus validaciones
│   │   │   └── presentation/ # UI de acceso y onboarding
│   │   │
│   │   ├── laundry_catalog/  # Catálogo de servicios y precios
│   │   │   ├── data/         # Data Sources para leer Firestore
│   │   │   ├── domain/       # Modelos LaundryService y Category
│   │   │   └── presentation/ # Pantallas de selección de ropa y filtros
│   │   │
│   │   ├── checkout_cart/    # Gestión de bolsa y pagos
│   │   │   ├── domain/       # Lógica de cálculo de descuentos y totales
│   │   │   └── presentation/ # Resumen de orden, pasarela de pago y confirmación
│   │   │
│   │   ├── order_tracking/   # Seguimiento y logística
│   │   │   ├── data/         # Streams activos de Firestore para la orden activa
│   │   │   ├── domain/       # Entidad Order y Timeline de estados
│   │   │   └── presentation/ # Stepper dinámico, mapas y notificaciones
│   │   │
│   │   └── admin_web_panel/  # EXCLUSIVO WEB: Gestión operativa
│   │       ├── data/         # Gestión de estados masivos de órdenes
│   │       └── presentation/ # Dashboard, Kanban y Reportería
│   │
│   ├── routing/              # NAVEGACIÓN DECLARATIVA (GoRouter)
│   └── shared/               # PROVIDERS GLOBALES (Riverpod Notifiers)
│
└── assets/                   # Iconografía, Imágenes de marca y animaciones Lottie

```

---

## 📊 3. Arquitectura de Datos (Firestore NoSQL Schema)

Diseño de colecciones optimizado para **baja latencia**.

### A. Colección: `users`

Cada documento es un perfil de cliente único.

* **Fields:** `uid`, `displayName`, `email`, `photoUrl`, `phone`, `createdAt`.
* **Sub-colección: `addresses**`: Lista de lugares de recogida (casa, oficina, gimnasio).
* **Sub-colección: `payment_methods**`: Tokens seguros de tarjetas (vía Stripe/MercadoPago).

### B. Colección: `services` (El Inventario)

* **Fields:** `serviceName`, `price`, `description`, `category` (Ropa de cama, Vestir, Delicado), `imageIcon`.

### C. Colección: `orders` (El Motor Transaccional)

* **Fields:** `orderId`, `customerId`, `totalAmount`, `currentStatus`, `itemsList` (Map Array).
* **History (Array de Maps):** `[ {status: 'recogido', time: timestamp}, {status: 'lavando', time: timestamp} ]`.
* **Logistics:** `pickupSlot` (Día/Hora), `deliverySlot`.

---

## 🎨 4. Diseño de la Plataforma Web (Admin Dashboard)

El Panel Web es la "Torre de Control" para el staff de la lavandería. Su diseño es funcional, no solo estético.

### A. Layout General: "Dashboard de Alta Eficiencia"

* **Barra Superior (TopBar):** Buscador global de pedidos por ID o nombre de cliente, notificaciones de nuevos pedidos en tiempo real y selector de sucursal.
* **Sidebar (Menú Lateral):** Iconos minimalistas para Dashboard, Pedidos, Clientes, Precios y Configuración.

### B. Vista de Gestión: "Kanban Operativo"

Es la pantalla donde ocurre la magia. Los pedidos se ven como tarjetas en columnas verticales:

* **Columna 1: Pendientes (Gris):** Órdenes recién hechas por clientes.
* **Columna 2: En Recogida (Amarillo):** El repartidor va en camino al domicilio.
* **Columna 3: En Lavandería (Azul):** La ropa está en máquinas o planchado.
* **Columna 4: Listas para Entrega (Verde):** Ropa limpia esperando salir.
* **Columna 5: Finalizadas (Blanco):** Historial del día.

### C. Detalles de Tarjeta (UI):

Cada tarjeta en el panel web muestra:

* ID del pedido en negrita.
* Contador de tiempo (¿Cuánto lleva en este estado?).
* Avatar del cliente.
* Etiqueta de "Urgente" si el cliente pagó por servicio express.

---

## 🎨 5. Diseño de la App Móvil (Interfaz Cliente)

### Experiencia "Fresh & Clean":

* **Home:** Un saludo amigable seguido de una tarjeta de "Estado de tu pedido actual" con una barra de progreso animada.
* **Catálogo:** Cards con bordes redondeados y sombras suaves. Al tocar una prenda, una pequeña animación de "añadido" vuela hacia el carrito.
* **Seguimiento:** Una vista de línea de tiempo (Timeline) donde cada paso tiene un icono: una bolsa para 'recogido', burbujas para 'lavando', una plancha para 'planchado'.

---

## 🛡️ 6. Seguridad y Reglas de Negocio

Para proteger los datos sin un servidor tradicional, usamos las **Firestore Security Rules**:

* **Privacidad:** `allow read, write: if request.auth.uid == resource.data.customerId;` (Un cliente solo ve lo suyo).
* **Integridad:** Los precios de los servicios son de solo lectura para los usuarios.
* **Validación:** Una orden no puede pasar de "Pendiente" a "Entregada" directamente; debe seguir el flujo lógico definido.

---

## 🚀 7. Resumen de Flujo para Antigravity

1. **Backend:** Configurar Firebase y desplegar el esquema de colecciones detallado.
2. **App Móvil:** Crear el flujo de compra (Catálogo -> Carrito -> Pago) y la vista de tracking reactiva.
3. **Panel Web:** Construir el Dashboard Kanban que permita al staff cambiar el estado de las órdenes con un click.
4. **Integración:** Asegurar que cuando el staff mueva una tarjeta en la Web, el cliente reciba una notificación push y su App cambie de estado visualmente al instante.

---

## 🚀 8. Prompt
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

---

Este plan extendido proporciona una visión de 360 grados de la infraestructura y el diseño. ¿Deseas que profundice en el diseño de los **reportes de ingresos** para el dueño o en el flujo de **notificaciones push**?
