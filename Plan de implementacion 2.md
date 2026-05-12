📋 Plan de Implementación Extenso: App "Lavandería Pro" (Flutter + Firebase)1. 🛠️ Ecosistema y Stack TecnológicoCategoríaHerramientaPropósitoFrameworkFlutter SDKDesarrollo multiplataforma.EstadoRiverpodGestión de estado reactiva, segura y sin contexto.BackendFirebaseAuth, Firestore (NoSQL) y Cloud Functions.Base de DatosSQL (MySQL/SQLite)Reportes financieros y estructura relacional detallada.NavegaciónGoRouterEnrutamiento declarativo y protección de rutas.2. 🏛️ Arquitectura de Base de Datos (DBA Design)El diseño relacional es fundamental para la integridad de los pedidos. Evitaremos el uso de tipos de datos imprecisos para los costos.2.1. Entidades y AtributosCLIENTE: Datos de perfil y geolocalización para entregas.SERVICIO: Catálogo de servicios (Lavado, Secado, Planchado, Tintorería).ORDEN: La cabecera del pedido que rastrea el ciclo de vida.DETALLE_ORDEN: Desglose de piezas y servicios aplicados a cada una.PAGO: Registro de transacciones financieras.2.2. Tablas del SistemaTablaAtributosTipo de DatoCLIENTEid_cliente (PK), nombre, email, telefonoINT, VARCHAR, VARCHAR, VARCHARSERVICIOid_servicio (PK), nombre, precio_unitarioINT, VARCHAR, DECIMAL(10,2)ORDENid_orden (PK), id_cliente (FK), estado, totalINT, INT, ENUM, DECIMAL(10,2)PAGOid_pago (PK), id_orden (FK), monto, metodoINT, INT, DECIMAL(10,2), ENUM3. 🚀 Script SQL de Estructura (bd_lavanderia.sql)Este script asegura que la base de datos sea relacionalmente íntegra.SQLCREATE DATABASE IF NOT EXISTS lavanderia_pro;
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
4. 📐 Arquitectura del Software (Flutter)Para escalar sin errores, utilizaremos Clean Architecture organizada por Features.Data Layer: Repositorios y fuentes de datos (Firebase/SQL).Domain Layer: Entidades de negocio y casos de uso (Usecases).Presentation Layer: Widgets de Flutter y Providers de Riverpod.Estructura de carpetas:Plaintextlib/
├── src/
│   ├── features/
│   │   ├── auth/          # Login/Registro
│   │   ├── catalog/       # Selección de servicios
│   │   ├── orders/        # Seguimiento y carrito
│   │   └── payments/      # Pasarela de pagos
│   ├── core/              # Temas, Router, Errores
│   └── shared/            # Widgets comunes
└── main.dart
5. 📦 Dependencias Seleccionadas (Sin Provider)flutter_riverpod: Gestión de estado global.riverpod_annotation: Generación de código para estados más limpios.cloud_firestore: Base de datos en tiempo real para estados de pedidos.firebase_auth: Seguridad y perfiles.sqflite: Base de datos relacional local.go_router: Navegación avanzada.freezed_annotation: Modelos de datos inmutables.6. ✅ Recomendaciones de ImplementaciónSincronización: Usa Firestore para el rastreo en vivo de la ropa y una base de datos SQL para los cierres de caja y auditoría.Precios: Siempre usa Decimal o convierte a centavos (int) en el código para evitar los errores de redondeo de los double.UX: Implementa un sistema de "historial de fotos" en el detalle de la orden para que el cliente vea el estado en que se recibió su prenda.7. 🤖 Prompt para Antigravity (Versión Riverpod)"Genera el código base para una App de Lavandería en Flutter utilizando Riverpod para la gestión de estado.Requerimientos:Modelos: Crea clases inmutables para 'Cliente', 'Orden' y 'Servicio'.Estado: Implementa un AsyncNotifier de Riverpod para manejar el flujo de una orden (Desde selección de servicios hasta pago).UI: Diseña una pantalla de tracking con un Stepper que consuma un StreamProvider de Firebase Firestore.Base de Datos: Proporciona un script SQL compatible con MySQL que incluya tablas normalizadas para Clientes, Servicios, Órdenes, Detalle_Orden y Pagos.Arquitectura: Sigue el patrón Feature-First. No utilices Provider, utiliza Riverpod con generación de código."
