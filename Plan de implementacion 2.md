Plan Maestro de Implementación de Ingeniería de Software: Versión Omni-Canal Ultra-Extendida
Sistema de Gestión Integral para Lavandería Profesional (Móvil y Web)

🏗️ 1. Filosofía de Arquitectura: "The Firebase Reactive Engine"
La aplicación no se comporta como una web tradicional de "petición y respuesta". Se basa en Streams. Esto significa que la base de datos "empuja" el estado de los procesos de lavado y planchado a los dispositivos (móvil y web) en milisegundos sin que el usuario tenga que refrescar.

Capas de Lógica en la Nube:
Capa de Identidad (Auth): Manejo de tokens JWT automáticos por Firebase para clientes y personal de la lavandería.

Capa de Persistencia (Firestore/NoSQL & Mapping Relacional): Base de datos con consistencia eventual y estructura de soporte para reportes de producción y tickets.

Capa de Cómputo (Cloud Functions): Procesamiento de lógica pesada (cálculo de kilogramos, asignación de lavadoras automáticas) fuera del dispositivo para ahorrar batería y datos al cliente.

Capa de Activos (Storage): Almacenamiento optimizado para imágenes de alta resolución de las prendas recibidas para el control de calidad, registro de manchas previas y lavado especial.

📂 2. Estructura de Carpetas: "Feature-First Industrial"
Esta organización garantiza que el código sea modular, escalable para nuevas sucursales y compatible con el patrón ChangeNotifier de Provider.

Plaintext
lib/
├── main.dart                 # Configuración de Firebase, MultiProvider y Crashlytics
├── app.dart                  # Root Widget, Configuración de Temas y GoRouter
│
├── src/
│   ├── core/                 # INFRAESTRUCTURA TRANSVERSAL
│   │   ├── common_widgets/   # Botones, campos de texto y esqueletos de carga (Shimmers)
│   │   ├── constants/        # IDs de Firebase, nombres de colecciones y estilos de lavandería
│   │   ├── theme/            # Design System: Colores, Tipografías y Sombras
│   │   └── utils/            # Helpers para manejo de fechas, cálculo de pesos y geolocalización
│   │
│   ├── features/             # UNIDADES DE NEGOCIO (Micro-Frontends)
│   │   ├── auth/             # Registro, Login, Recuperación y Perfil del Cliente/Empleado
│   │   │   ├── data/         # Repositorios que envuelven FirebaseAuth
│   │   │   ├── domain/       # Entidades AppUser y sus validaciones
│   │   │   └── presentation/ # UI de acceso y onboarding (Provider Consumer)
│   │   │
│   │   ├── laundry_catalog/  # Catálogo de servicios de lavado, secado y tintorería
│   │   │   ├── data/         # Data Sources para leer Firestore (Tarifas por kilo o pieza)
│   │   │   ├── domain/       # Modelos LaundryService y Category (Lavado, Planchado, Dry Clean)
│   │   │   └── presentation/ # Pantallas de selección de prendas, tipo de carga y filtros
│   │   │
│   │   ├── checkout_cart/    # Gestión de tique de servicio y pagos
│   │   │   ├── domain/       # Lógica de cálculo de descuentos, cupones y totales de orden
│   │   │   └── presentation/ # Resumen del tique, pasarela de pago y confirmación de recepción
│   │   │
│   │   ├── order_tracking/   # Seguimiento del proceso de lavado y logística de reparto
│   │   │   ├── data/         # Streams activos de Firestore para la orden en proceso
│   │   │   ├── domain/       # Entidad Order y Timeline de estados (Recibido -> Lavado -> Listo)
│   │   │   └── presentation/ # Stepper dinámico de lavado, mapas de entrega y notificaciones
│   │   │
│   │   └── admin_web_panel/  # EXCLUSIVO WEB: Gestión operativa del mostrador y planta
│   │       ├── data/         # Gestión de estados masivos de órdenes de lavado
│   │       └── presentation/ # Dashboard operativo, Kanban de producción y Reportería
│   │
│   ├── routing/              # NAVEGACIÓN DECLARATIVA (GoRouter)
│   └── providers/            # GESTIÓN DE ESTADO (Provider: ChangeNotifiers)
│       ├── cart_provider.dart
│       ├── auth_provider.dart
│       └── order_status_provider.dart
│
└── assets/                   # Iconografía de prendas, Imágenes de marca y animaciones Lottie de lavado
📦 2.5 Configuración de Dependencias Críticas (Estructura pubspec)
Para dar soporte a la arquitectura reactiva y multientorno de la lavandería, el sistema requiere la integración de las siguientes librerías:

Gestión de Estado y Lógica:
provider: El motor principal para el manejo de ChangeNotifiers y la inyección de dependencias del flujo de órdenes en todo el árbol de widgets.

Infraestructura Firebase (Backend as a Service):
firebase_core: Requisito base para la vinculación de los servicios de Google.

firebase_auth: Gestión de sesiones, tokens JWT y seguridad de identidad de clientes y operadores.

cloud_firestore: Implementación de los Streams reactivos para la base de datos NoSQL con soporte relacional de tiques.

firebase_storage: Repositorio para el almacenamiento de evidencias fotográficas del estado pre-lavado de las prendas (control de daños).

firebase_messaging: Sistema de alertas push para avisar que la ropa está lista o en camino.

Navegación y Estructura:
go_router: Motor para la navegación declarativa, esencial para el Panel Web Administrativo y rutas de rastreo en el móvil.

Utilidades de Datos y UI:
intl: Herramienta indispensable para el formateo de moneda (costo del servicio) y fechas estimadas de entrega.

google_fonts: Implementación del sistema tipográfico corporativo de la lavandería.

cached_network_image: Optimización de memoria para las fotos del catálogo de servicios y prendas, evitando descargas redundantes.

shimmer: Generación de efectos de carga elegantes para la lista de órdenes en proceso.

lottie: Soporte para animaciones vectoriales en los estados de "Ropa Lavándose" y "Pedido Entregado".

Logística y Localización:
Maps_flutter: Visualización de la ruta del chofer/repartidor de la lavandería a domicilio.

geolocator: Obtención de coordenadas precisas para la recogida de bolsas de ropa y su entrega final.

3. Fases de Ejecución del Proyecto
Para materializar este Plan Maestro de la lavandería, se establecen las siguientes etapas cronológicas:

Fase I: Cimentación e Infraestructura Cloud

Configuración de Environments: Creación de proyectos en Firebase (Dev/Prod) y vinculación de Apps Android/iOS/Web.

Implementación del Core: Estructuración de la carpeta lib/src/core, configuración del ThemeData (paleta azul/limpieza) y rutas con GoRouter.

Despliegue de DB Inicial: Creación de las colecciones en Firestore basadas en las entidades de SUCURSAL, SERVICIO (lavado por kilo, edredones, tintorería) e INSUMO.

Fase II: Gestión de Identidad y Acceso (Auth)

Lógica de Autenticación: Desarrollo del auth_provider.dart y repositorios de FirebaseAuth.

Perfiles: Creación de documentos en la colección CLIENTE y EMPLEADO (lavadores, planchadores, repartidores) al momento del registro.

Seguridad: Implementación de las primeras Security Rules para que solo el staff acceda al Panel Web de Control.

Fase III: Catálogo Reactivo y Gestión de Estados (Provider)

Data Sourcing: Conexión del módulo laundry_catalog con Firestore mediante Streams en tiempo real.

Lógica de Carrito: Desarrollo del cart_provider.dart para manejar la selección de prendas y servicios de lavado en tiempo real.

Modelado: Implementación de las entidades de dominio para PRENDA_ORDEN y lógica de cálculo de precios base y pesos mínimos.

Fase IV: Operativa Web y Kanban Tower

Dashboard Administrativo: Construcción de la UI del admin_web_panel para el mostrador de la lavandería.

Motor Kanban: Implementación del sistema de columnas reactivas que escuchan el estado de la colección ORDEN en la planta de lavado.

Módulo Operativo: CRUD de INSUMOS (detergentes, suavizantes, ganchos) y PROVEEDORES para el control estricto de inventario desde la web.

Fase V: Logística, Pagos y Notificaciones

Flujo de Pago: Integración de la entidad PAGO y cierre de la ORDEN de servicio.

Tracking Step-by-Step: Desarrollo del order_tracking en la app móvil que reacciona de inmediato cuando el operador cambia la orden de columna en el Kanban Web.

Cloud Messaging: Configuración de alertas automáticas para cambios de estado (ej: "Tu ropa ha entrado a la lavadora" o "Tu pedido está listo para recolección").

Fase VI: Refinamiento, QA y Lanzamiento

Optimización de Activos: Configuración de Storage para fotos de control de calidad antes del proceso de lavado.

Pruebas de Integridad: Validación de reglas de negocio (evitar que una orden pase a entregada si no registra pago previo).

Producción: Compilación final y despliegue en las Stores de aplicaciones y Firebase Web Hosting.

📊 4. Arquitectura de Datos Detallada (Estructura de Tablas)
Se integran las entidades del sistema de lavandería para garantizar la integridad referencial y el control total de la operación industrial.

A. Entidades de Usuario y Personal
CLIENTE: Personas que solicitan el servicio de lavandería.

Atributos: id_cliente (PK), nombre, telefono (IDX), email, direccion, fecha_registro, activo.

EMPLEADO: Personal operativo de la lavandería (atención, lavado, planchado, reparto).

Atributos: id_empleado (PK), id_sucursal (FK), nombre, puesto, telefono, fecha_alta, activo.

SUCURSAL: Locales físicos de la empresa de lavandería.

Atributos: id_sucursal (PK), nombre, direccion, telefono, activa.

B. Entidades de Operación y Catálogo
SERVICIO: Tipos de procesos de limpieza ofrecidos (Lavado por kilo, Planchado por pieza, Tintorería, Lavado de Edredones).

Atributos: id_servicio (PK), nombre, descripcion, precio_base (DECIMAL), tiempo_estimado_hrs, activo.

ORDEN: Pedido o tique central del servicio de lavandería.

Atributos: id_orden (PK), id_cliente (FK), id_empleado (FK), id_sucursal (FK), fecha_ingreso, fecha_entrega_est, fecha_entrega_real, estado (IDX: recibido/en_proceso/listo/entregado), notas.

PRENDA_ORDEN: Detalle desglosado de las prendas y servicios dentro del tique.

Atributos: id_detalle (PK), id_orden (FK), id_servicio (FK), id_insumo (FK - opcional para tratamientos especiales), descripcion_prenda (ej: Camisa, Pantalón, Edredón Matrimonial), color, cantidad, precio_unitario, observaciones (ej: Mancha de grasa, rasgadura previa).

C. Entidades Financieras e Inventario
PAGO: Registro financiero de la orden de lavandería.

Atributos: id_pago (PK), id_orden (FK), monto_total, descuento, monto_pagado, metodo_pago (ENUM: efectivo/tarjeta/transferencia), fecha_pago.

INSUMO: Productos químicos y de empaque utilizados en la lavandería (Detergente industrial, suavizante, desmanchador, ganchos, bolsas plásticas).

Atributos: id_insumo (PK), id_proveedor (FK), nombre, unidad (ej: Litros, Piezas), stock_actual, stock_minimo, costo_unitario.

PROVEEDOR: Empresas distribuidoras de químicos e insumos de lavandería.

Atributos: id_proveedor (PK), nombre, contacto, telefono, email.

🎨 5. Diseño de la Plataforma Web (Admin Dashboard)
El Panel Web es la "Torre de Control" para el staff técnico y operativo de la lavandería. Su diseño es meramente funcional y enfocado en la productividad.

A. Layout General: "Dashboard de Alta Eficiencia"
Barra Superior (TopBar): Buscador global de tiques por ID de orden o nombre de cliente, notificaciones en tiempo real para nuevas solicitudes de recolección a domicilio y un selector para alternar entre sucursales de lavandería.

Sidebar (Menú Lateral): Iconos minimalistas para Dashboard de Producción, Órdenes de Lavado, Clientes, Catálogo de Precios/Servicios e Inventario de Insumos.

B. Vista de Gestión: "Kanban Operativo de Planta"
Es la pantalla operativa central. Los tiques de lavandería se organizan como tarjetas visuales en columnas verticales según su estado físico actual:

Columna 1: Pendientes (Gris): Órdenes recién generadas en mostrador o solicitadas por la app.

Columna 2: En Recogida (Amarillo): El repartidor va en camino al domicilio a recolectar la ropa.

Columna 3: En Lavandería (Azul): La ropa se encuentra actualmente en proceso de lavado, secado o planchado en las máquinas.

Columna 4: Listas para Entrega (Verde): Ropa limpia, planchada, embolsada y empacada esperando en anaquel o lista para el reparto.

Columna 5: Finalizadas (Blanco): Historial de órdenes entregadas con éxito durante el día.

📱 6. Despliegue Multiplataforma (iOS, Android, Web)
El código fuente de la lavandería se compila desde una única base Flutter, optimizando la experiencia según el entorno:

iOS: Implementación de gestos nativos y compatibilidad con Apple Pay para el pago rápido del servicio desde la app móvil del cliente.

Android: Notificaciones push con canales de alta prioridad para avisar cambios críticos en el estado del tique de ropa.

Web Administrativa: Layout responsivo tipo desktop optimizado para pantallas de mostrador y tablets en planta, permitiendo el arrastre ágil de tarjetas (drag & drop) en el panel Kanban y un control eficiente de inventarios de insumos químicos.

🛡️ 7. Seguridad y Reglas de Negocio
Para proteger la información sin depender de un servidor tradicional pesado, implementamos las Firestore Security Rules:

Privacidad: allow read, write: if request.auth.uid == resource.data.customerId; (Un cliente de la lavandería solo puede auditar y seguir sus propias órdenes).

Integridad: Las tarifas de los servicios de lavado del catálogo son de solo lectura estricta para los usuarios finales.

Validación: Una orden de lavandería no puede saltarse pasos lógicos esenciales; por ejemplo, el sistema bloquea el paso directo de "Pendiente" a "Entregada" sin haber cruzado previamente por "En Lavandería" y "Lista para Entrega".

🚀 8. Resumen de Flujo para Antigravity
Backend: Configurar Firebase y desplegar el esquema de tablas relacionales detallado (Clientes, Órdenes de Lavado, Pagos, Insumos de Planta, etc.).

Estado Global: Inyectar los ChangeNotifiers (Provider) en la raíz de la aplicación para que la información del flujo de ropa se distribuya de forma limpia entre pantallas.

App Móvil (iOS/Android): Diseñar la experiencia de selección del tipo de lavado, confirmación de carrito y la vista de seguimiento reactivo basada en la tabla ORDEN.

Panel Web: Construir el Dashboard Kanban industrial para la planta y los módulos de administración de EMPLEADOS e inventario de insumos con PROVEEDORES.

Integración: Garantizar que cuando el operador en sucursal arrastre una tarjeta de tique a la columna "Lista para Entrega" en la interfaz Web, el OrderStatusProvider notifique instantáneamente a la App móvil para actualizar la pantalla del cliente y disparar la alerta push.

🚀 9. Prompt para Antigravity: App "Lavandería Pro" (Full Provider Legacy/Standard)
System Context: "Actúa como un Arquitecto de Software experto en Flutter y DBA. El objetivo es generar el andamiaje técnico de una aplicación de lavandería profesional utilizando Provider como gestor de estado único y una estructura relacional para los datos."

Prompt Principal: "Genera la estructura técnica y visual para una aplicación de lavandería en Flutter utilizando Provider (ChangeNotifierProvider y MultiProvider) como única solución de gestión de estado. No utilices Riverpod, Bloc ni GetX.

Arquitectura de Datos (Enfoque Relacional): Diseña un esquema de base de datos SQL normalizado y escalable para una empresa de lavandería que incluya integridad referencial:

CLIENTE: (id, nombre, email, direccion_entrega).

SERVICIO: (id, nombre, precio_decimal, categoria_enum [lavado_kilo, planchado, tintoreria]).

ORDEN: (id, id_cliente, fecha_creacion, estado_actual_enum [recibido, en_lavado, listo, entregado]).

DETALLE_ORDEN: (id, id_orden, id_servicio, cantidad, subtotal_decimal).

PAGO: (id, id_orden, monto_decimal, metodo_pago_enum).
(Genera el script SQL DDL compatible con MySQL/PostgreSQL usando tipos DECIMAL para evitar errores de precisión en la moneda del servicio).

Gestión de Estado con Provider:

Implementa un ChangeNotifier para OrderProvider que gestione el flujo de los tiques de lavandería (creación, actualización de estado en la línea de producción).

Utiliza un StreamProvider para la escucha pasiva de actualizaciones del estado de lavado desde Firebase/Backend.

Crea un ChangeNotifier específico para CartProvider que maneje la lógica del tique de compra (añadir prendas, quitar servicios, calcular peso/totales).

Configura el MultiProvider en la raíz de la aplicación (main.dart) para la correcta inyección de estas dependencias.

Interfaz de Usuario (UI):

Diseño: Estilo minimalista, limpio (tonos azules/blancos) y profesional.

Componentes: Un ServiceSelector con cards interactivas de servicios de lavado, un OrderStepper para el tracking visual del proceso de la ropa (Recibido -> Lavando -> Planchando -> Listo) y un PaymentSummary que use Consumer para actualizaciones granulares del total del tique.

Navegación: Configura GoRouter integrado con la lógica de autenticación del UserProvider.

Entregables de Código:

Modelos: Clases Dart estándar con métodos toMap y fromMap para persistencia de datos de la lavandería.

Estructura: Organización de carpetas por capas (Data, Models, Providers, UI).

Optimización: Uso de context.select y Consumer para evitar reconstrucciones (re-builds) innecesarias de la interfaz de usuario al actualizar estados de lavado."
