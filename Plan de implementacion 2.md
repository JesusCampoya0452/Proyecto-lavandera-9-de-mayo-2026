Este es el **Plan Maestro de Implementación de Ingeniería de Software: Versión Omni-Canal Ultra-Extendida**, actualizado para integrar el esquema de base de datos detallado, manteniendo la compatibilidad con **Flutter (iOS, Android, Web)** y la gestión de estado mediante **Provider**.

---

## 🏗️ 1. Filosofía de Arquitectura: "The Firebase Reactive Engine"

La aplicación no se comporta como una web tradicional de "petición y respuesta". Se basa en **Streams**. Esto significa que la base de datos "empuja" la información a los dispositivos (móvil y web) en milisegundos sin que el usuario tenga que refrescar.

### Capas de Lógica en la Nube:

* **Capa de Identidad (Auth):** Manejo de tokens JWT automáticos por Firebase.
* **Capa de Persistencia (Firestore/NoSQL & Mapping Relacional):** Base de datos con consistencia eventual y estructura de soporte para reportes.
* **Capa de Cómputo (Cloud Functions):** Procesamiento de lógica pesada fuera del dispositivo para ahorrar batería y datos al cliente.
* **Capa de Activos (Storage):** Almacenamiento optimizado para imágenes de alta resolución de prendas para control de calidad.

---

## 📂 2. Estructura de Carpetas: "Feature-First Industrial"

Esta organización garantiza que el código sea modular y compatible con el patrón **ChangeNotifier** de **Provider**.

```text
lib/
├── main.dart                 # Configuración de Firebase, MultiProvider y Crashlytics
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
│   │   │   └── presentation/ # UI de acceso y onboarding (Provider Consumer)
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
│   └── providers/            # GESTIÓN DE ESTADO (Provider: ChangeNotifiers)
│       ├── cart_provider.dart
│       ├── auth_provider.dart
│       └── order_status_provider.dart
│
└── assets/                   # Iconografía, Imágenes de marca y animaciones Lottie

```

---

## 3. Fases de Ejecución del Proyecto
  Para materializar este Plan Maestro, se establecen las siguientes etapas cronológicas:
  
  ### Fase I: 
    Cimentación e Infraestructura Cloud
    Configuración de Environments: Creación de proyectos en Firebase (Dev/Prod) y vinculación de Apps Android/iOS/Web.
    
    Implementación del Core: Estructuración de la carpeta lib/src/core, configuración del ThemeData y el sistema de rutas con GoRouter.
    
    Despliegue de DB Inicial: Creación de las colecciones en Firestore basadas en las entidades de SUCURSAL, SERVICIO e INSUMO.
  
  ### Fase II: 
    Gestión de Identidad y Acceso (Auth)
    Lógica de Autenticación: Desarrollo del auth_provider.dart y repositorios de FirebaseAuth.
    
    Perfiles: Creación de documentos en la colección CLIENTE y EMPLEADO al momento del registro.
    
    Seguridad: Implementación de las primeras Security Rules para que solo el staff acceda al Panel Web.
  
  ### Fase III: 
    Catálogo Reactivo y Gestión de Estados (Provider)
    Data Sourcing: Conexión de laundry_catalog con Firestore mediante Streams.
    
    Lógica de Carrito: Desarrollo del cart_provider.dart para manejar la selección de prendas y servicios en tiempo real.
    
    Modelado: Implementación de las entidades de dominio para PRENDA_ORDEN y lógica de cálculo de precios base.
  
  ### Fase IV: 
    Operativa Web y Kanban Tower
    Dashboard Administrativo: Construcción de la UI del admin_web_panel.
    
    Motor Kanban: Implementación del sistema de columnas reactivas que escuchan la colección ORDEN.
    
    Módulo Operativo: CRUD de INSUMOS y PROVEEDORES para el control de inventario desde la web.
  
  ### Fase V: 
    Logística, Pagos y Notificaciones
    Flujo de Pago: Integración de la entidad PAGO y cierre de la ORDEN.
    
    Tracking Step-by-Step: Desarrollo del order_tracking en móvil que reacciona a los movimientos de tarjetas en el Kanban Web.
    
    Cloud Messaging: Configuración de alertas automáticas para cambios de estado (ej: "Tu ropa está lista").
    
  ### Fase VI: 
    Refinamiento, QA y Lanzamiento
    Optimización de Activos: Configuración de Storage para fotos de control de calidad.
    
    Pruebas de Integridad: Validación de reglas de negocio (evitar saltos de estado inválidos).
    
    Producción: Compilación final y despliegue en Stores y Web Hosting.

## 📊 4. Arquitectura de Datos Detallada (Estructura de Tablas)

Se integran las entidades del sistema para garantizar la integridad referencial y el control total de la operación.

### A. Entidades de Usuario y Personal

* **CLIENTE:** Personas que solicitan el servicio.
* *Atributos:* `id_cliente` (PK), `nombre`, `telefono` (IDX), `email`, `direccion`, `fecha_registro`, `activo`.


* **EMPLEADO:** Personal de la lavandería.
* *Atributos:* `id_empleado` (PK), `id_sucursal` (FK), `nombre`, `puesto`, `telefono`, `fecha_alta`, `activo`.


* **SUCURSAL:** Locales de la empresa.
* *Atributos:* `id_sucursal` (PK), `nombre`, `direccion`, `telefono`, `activa`.



### B. Entidades de Operación y Catálogo

* **SERVICIO:** Tipos de proceso ofrecidos.
* *Atributos:* `id_servicio` (PK), `nombre`, `descripcion`, `precio_base` (DECIMAL), `tiempo_estimado_hrs`, `activo`.


* **ORDEN:** Pedido central del sistema.
* *Atributos:* `id_orden` (PK), `id_cliente` (FK), `id_empleado` (FK), `id_sucursal` (FK), `fecha_ingreso`, `fecha_entrega_est`, `fecha_entrega_real`, `estado` (IDX: recibido/en_proceso/listo/entregado), `notas`.


* **PRENDA_ORDEN:** Detalle de artículos por orden.
* *Atributos:* `id_detalle` (PK), `id_orden` (FK), `id_servicio` (FK), `id_insumo` (FK - opcional), `descripcion_prenda`, `color`, `cantidad`, `precio_unitario`, `observaciones`.



### C. Entidades Financieras e Inventario

* **PAGO:** Registro financiero de la orden.
* *Atributos:* `id_pago` (PK), `id_orden` (FK), `monto_total`, `descuento`, `monto_pagado`, `metodo_pago` (ENUM: efectivo/tarjeta/transferencia), `fecha_pago`.


* **INSUMO:** Productos e inventario.
* *Atributos:* `id_insumo` (PK), `id_proveedor` (FK), `nombre`, `unidad`, `stock_actual`, `stock_minimo`, `costo_unitario`.


* **PROVEEDOR:** Empresas suministradoras.
* *Atributos:* `id_proveedor` (PK), `nombre`, `contacto`, `telefono`, `email`.



---

## 🎨 5. Diseño de la Plataforma Web (Admin Dashboard)

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

---

## 📱 6. Despliegue Multiplataforma (iOS, Android, Web)

El código se compila desde una única base **Flutter**, adaptándose a cada entorno:

* **iOS:** Implementación de gestos nativos y compatibilidad con Apple Pay.
* **Android:** Notificaciones push de alta prioridad para cambios de estado de lavado.
* **Web Administrativa:** Layout responsivo tipo desktop que permite el arrastre de tarjetas (drag & drop) en el panel Kanban y gestión de inventario de **INSUMOS**.

---

## 🛡️ 7. Seguridad y Reglas de Negocio

Para proteger los datos sin un servidor tradicional, usamos las **Firestore Security Rules**:

* **Privacidad:** `allow read, write: if request.auth.uid == resource.data.customerId;` (Un cliente solo ve lo suyo).
* **Integridad:** Los precios de los servicios son de solo lectura para los usuarios.
* **Validación:** Una orden no puede pasar de "Pendiente" a "Entregada" directamente; debe seguir el flujo lógico definido.

---

## 🚀 8. Resumen de Flujo para Antigravity

1. **Backend:** Configurar Firebase y desplegar el esquema de tablas detallado (Clientes, Órdenes, Pagos, Insumos, etc.).
2. **Estado Global:** Inyectar los `ChangeNotifiers` (Provider) en el root de la app para que la información fluya entre pantallas.
3. **App Móvil (iOS/Android):** Crear el flujo de compra y la vista de tracking reactiva basada en la tabla `ORDEN`.
4. **Panel Web:** Construir el Dashboard Kanban y los módulos de gestión de `EMPLEADOS` y `PROVEEDORES`.
5. **Integración:** Asegurar que cuando el staff mueva una tarjeta en la Web, el `OrderProvider` notifique a la App móvil para actualizar la UI del cliente al instante.

## 🚀 9. Prompt para Antigravity: App "Lavandería Pro" (Full Provider Legacy/Standard)
System Context:
"Actúa como un Arquitecto de Software experto en Flutter y DBA. El objetivo es generar el andamiaje técnico de una aplicación de lavandería profesional utilizando Provider como gestor de estado único y una estructura relacional para los datos."

Prompt Principal:
"Genera la estructura técnica y visual para una aplicación de lavandería en Flutter utilizando Provider (ChangeNotifierProvider y MultiProvider) como única solución de gestión de estado. No utilices Riverpod, Bloc ni GetX.

1. Arquitectura de Datos (Enfoque Relacional):
Diseña un esquema de base de datos SQL normalizado y escalable que incluya integridad referencial:

CLIENTE: (id, nombre, email, direccion_entrega).

SERVICIO: (id, nombre, precio_decimal, categoria_enum).

ORDEN: (id, id_cliente, fecha_creacion, estado_actual_enum).

DETALLE_ORDEN: (id, id_orden, id_servicio, cantidad, subtotal_decimal).

PAGO: (id, id_orden, monto_decimal, metodo_pago_enum).
(Genera el script SQL DDL compatible con MySQL/PostgreSQL usando tipos DECIMAL para evitar errores de precisión en moneda).

2. Gestión de Estado con Provider:

Implementa un ChangeNotifier para OrderProvider que gestione el flujo de las órdenes (creación, actualización de estado).

Utiliza un StreamProvider para la escucha pasiva de actualizaciones de estado desde Firebase/Backend.

Crea un ChangeNotifier específico para CartProvider que maneje la lógica del carrito de servicios (añadir/quitar/calcular total).

Configura el MultiProvider en la raíz de la aplicación (main.dart) para la inyección de estas dependencias.

3. Interfaz de Usuario (UI):

Diseño: Estilo minimalista y profesional.

Componentes: Un ServiceSelector con cards interactivas, un OrderStepper para el tracking del proceso de lavado y un PaymentSummary que use Consumer para actualizaciones granulares.

Navegación: Configura GoRouter integrado con la lógica de autenticación del UserProvider.

4. Entregables de Código:

Modelos: Clases Dart estándar con métodos toMap y fromMap para persistencia.

Estructura: Organización de carpetas por capas (Data, Models, Providers, UI).

Optimización: Uso de context.select y Consumer para evitar reconstrucciones (re-builds) innecesarias de la UI."
