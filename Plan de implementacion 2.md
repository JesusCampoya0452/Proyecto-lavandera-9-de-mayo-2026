Este es el **Plan Maestro de Implementación de Ingeniería de Software: Nivel Infraestructura Crítica**. He expandido cada sección al máximo detalle técnico, legal, operativo y arquitectónico para que no exista ambigüedad alguna durante la construcción de **Lavandería Pro**.

---

## 🏗️ 1. Ingeniería de Software y Patrones de Diseño

Para un sistema que maneja transacciones financieras y logística física, la robustez no es opcional. Implementaremos un patrón **DDD (Domain-Driven Design)** dentro de la estructura de capas.

### A. Capas de Abstracción Profunda

* **Domain Layer (El Corazón):** Contiene la lógica que no cambia, independientemente de si usamos Flutter, Web o una consola. Aquí residen las **Value Objects** (ej. `Money`, `Address`, `PhoneNumber`) que se validan a sí mismas al ser creadas.
* **Application Layer (Los Directores):** Aquí viven los **Use Cases**. Por ejemplo, el caso de uso `PlaceOrder` coordina al `UserRepository`, al `PaymentService` y al `NotificationService`.
* **Infrastructure Layer (Los Traductores):** Implementaciones específicas de frameworks. Si decidimos cambiar Firebase por AWS Amplify, solo tocamos esta capa.

### B. Gestión de Estado: El Grafo de Dependencias

Usaremos **Riverpod Generator** para crear un grafo de dependencias inmutable.

* **`ref.watch`**: Para dependencias reactivas (la UI se actualiza).
* **`ref.listen`**: Para efectos secundarios (mostrar un SnackBar cuando falla el pago).
* **`ref.read`**: Únicamente dentro de funciones de callback (botones).

---

## 📂 2. Arquitectura de Archivos y Módulos (Extendido)

Cada *feature* es un micro-ecosistema. Ejemplo para el módulo de `Orders`:

```text
lib/src/features/orders/
├── data/
│   ├── dtos/                    # Data Transfer Objects (JSON mapping)
│   │   ├── order_dto.dart
│   │   └── order_item_dto.dart
│   ├── repositories/            # Implementación con SQL/Firebase
│   │   └── firebase_orders_repository.dart
│   └── sources/                 # Clientes de red o base de datos
│       └── orders_local_dao.dart
├── domain/
│   ├── entities/                # Modelos puros de Dart (Freezed)
│   │   └── order.dart
│   ├── repository_interfaces/   # Contratos abstractos
│   │   └── i_orders_repository.dart
│   └── use_cases/               # Lógica de negocio específica
│       ├── get_active_orders.dart
│       └── cancel_order.dart
└── presentation/
    ├── controllers/             # NotifierProviders (AsyncNotifier)
    │   └── order_list_controller.dart
    ├── screens/                 # Pantallas principales
    │   └── order_tracking_screen.dart
    └── widgets/                 # Componentes exclusivos de la feature
        └── tracking_stepper.dart

```

---

## 📊 3. Diseño de Base de Datos y Persistencia Políglota

No guardaremos todo en un solo lugar. Usaremos el almacenamiento adecuado para cada tipo de dato.

### A. SQL Local (Drift/SQLite) - Para Operación Offline

Diseñado para que el repartidor pueda marcar una entrega incluso en un sótano sin señal.

* **Table `SyncQueue**`: Guarda las operaciones pendientes de subir a la nube.
* **Table `StaticAssets**`: Caché de imágenes de prendas y precios para carga instantánea ($<100ms$).

### B. NoSQL Real-time (Firestore) - Para el Cliente

Estructura de colecciones optimizada para lectura:

* `/users/{uid}/active_orders/`: Sub-colección para consultas ultra rápidas del cliente.
* `/system_config/prices`: Documento único que la app descarga al inicio para asegurar paridad de precios.

### C. Script DDL de Alta Integridad (PostgreSQL/MySQL)

```sql
CREATE TYPE order_status AS ENUM ('recogido', 'lavando', 'secando', 'listo', 'entregado');

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES users(id),
    total_amount DECIMAL(12, 2) NOT NULL CHECK (total_amount >= 0),
    tax_amount DECIMAL(12, 2) GENERATED ALWAYS AS (total_amount * 0.16) STORED,
    status order_status DEFAULT 'recogido',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_orders_client_status ON orders(client_id, status);

```

---

## 🎨 4. Design System Pro (UI/UX)

El diseño no es solo estético, es funcional. Implementaremos un **Atomic Design System**.

### Átomos y Moléculas

* **`LaundryIcon`**: Iconografía personalizada con trazos suaves.
* **`PriceTag`**: Componente con soporte multimoneda y formato regional.
* **`StatusChip`**: Cambia dinámicamente de color:
* `lavando`: Azul con animación de pulso.
* `listo`: Verde esmeralda con check icon.



### Experiencia Web (Admin Panel)

* **Dashboard de Control de Flujo**: Una vista de "Torre de Control" donde el dueño ve cuántos kilos de ropa hay en cada etapa del proceso.
* **Mapa de Calor**: Visualización de zonas de la ciudad con más pedidos para optimizar las rutas de los repartidores.

---

## 🛡️ 5. Seguridad, DevOps y QA

### A. Seguridad (Zero Trust)

* **Cifrado**: Todos los datos sensibles (direcciones, tokens) se guardan en el **Secure Storage** del dispositivo (Keystore en Android / Keychain en iOS).
* **SSL Pinning**: Para evitar ataques *Man-in-the-Middle* en la comunicación con la pasarela de pagos.

### B. Pipeline de CI/CD (Automatización)

1. **Linter**: Verificación estricta de reglas de estilo de código.
2. **Unit Tests**: Cobertura mínima del **80%** en la capa de Domain.
3. **Goldens Tests**: Pruebas visuales para asegurar que la UI no se rompa en diferentes tamaños de pantalla.
4. **Codemagic/GitHub Actions**: Compilación automática y subida a TestFlight y Google Play Console.

---

## 🚀 6. Workflow de Ejecución (Cronograma de Ingeniería)

### Mes 1: Cimientos y Auth

* Configuración de entornos (Dev, Staging, Prod).
* Implementación de flujo de Auth con Riverpod (Social Login + OTP de teléfono).
* Estructura básica de navegación con GoRouter.

### Mes 2: El Motor de Lavandería

* Desarrollo del catálogo dinámico.
* Lógica compleja del carrito (descuentos, cargos adicionales por prendas delicadas).
* Integración de Firebase Cloud Messaging para notificaciones de cambio de estado.

### Mes 3: Fintech y Logística

* Integración de SDK de pagos (Stripe/Conekta/MercadoPago).
* Módulo de geolocalización para repartidores.
* Generación de facturas en PDF automáticas.

---

## 📝 Prompt Definitivo para Antigravity (Sin Modificar)

> **"Genera la estructura técnica y visual para una aplicación de lavandería en Flutter eliminando por completo el uso de Provider y utilizando Riverpod (con riverpod_generator) como única solución de gestión de estado.**
> **1. Arquitectura de Datos (Enfoque Relacional):**
> **Diseña un esquema de base de datos SQL normalizado y escalable que incluya las siguientes entidades con integridad referencial: CLIENTE, SERVICIO, ORDEN, DETALLE_ORDEN, PAGO. (Genera el script SQL DDL compatible con MySQL/PostgreSQL usando tipos DECIMAL para montos monetarios).**
> **2. Gestión de Estado con Riverpod:**
> **Crea un AsyncNotifierProvider para gestionar el estado de las órdenes en tiempo real. Implementa un StreamProvider para escuchar los cambios de estado desde Firebase. Crea un StateProvider para el manejo del carrito. Asegura que no exista ninguna dependencia de 'provider'.**
> **3. Interfaz de Usuario (UI):**
> **Diseño minimalista, ServiceSelector con cards modernas, OrderStepper para progreso y PaymentSummary.**
> **4. Entregables de Código:**
> **Modelos Freezed, Estructura Feature-First, Lógica de validación."**

Este plan expandido garantiza que el sistema sea **mantenible por años**, capaz de soportar picos de demanda y con una base de datos digna de una entidad bancaria. ¿Deseas que profundice en la lógica de los algoritmos de optimización de rutas para los repartidores?
