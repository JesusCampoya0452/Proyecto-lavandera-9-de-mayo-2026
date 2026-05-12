Entiendo que deseas llevar este plan al siguiente nivel utilizando **Antigravity** (herramienta de diseño/generación basada en IA). Para que la herramienta interprete correctamente la complejidad de una App de Lavandería con una base de datos relacional, el prompt debe ser técnico, estructural y visualmente descriptivo.

Aquí tienes el prompt optimizado para generar el prototipo o la estructura inicial en Antigravity:

---

### 🚀 Prompt para Antigravity: App "Lavandería Pro"

**System Context:**

> "Actúa como un Senior Fullstack Developer y Diseñador de UX/UI. El objetivo es crear el blueprint técnico y visual de una aplicación de lavandería profesional llamada 'Lavandería Pro'."

**Prompt Principal:**
"Genera la estructura completa para una aplicación móvil en **Flutter** conectada a **Firebase**, diseñada específicamente para la gestión de servicios de lavandería. La arquitectura debe basarse en los siguientes pilares:

**1. Arquitectura de Base de Datos (Relacional):**
Diseña un esquema de datos optimizado que incluya las entidades:

* **CLIENTES:** (id, nombre, email, teléfono, dirección_geo).
* **SERVICIOS:** (id, nombre_servicio, precio_decimal, unidad_medida).
* **ORDENES:** (id, id_cliente, fecha_ingreso, fecha_entrega, estado_enum: [Recibido, Lavando, Planchado, Listo, Entregado]).
* **PAGOS:** (id, id_orden, monto_decimal, metodo_pago).

**2. Interfaz de Usuario (UX/UI):**

* **Estilo Visual:** Limpio, minimalista, con una paleta de colores basada en Azul Cian (#00BCD4) y Blanco Puro para transmitir limpieza.
* **Pantalla Principal:** Un Dashboard que muestre un 'Stepper' vertical u horizontal con el progreso en tiempo real de la orden activa del usuario.
* **Catálogo:** Una lista de tarjetas interactivas para seleccionar servicios (Lavado por KG, Tintorería, Planchado).

**3. Flujo Lógico y Funcionalidades:**

* Implementación de **State Management** (Riverpod o Provider).
* Integración de un carrito de compras dinámico que calcule subtotales y taxes automáticamente.
* Sistema de notificaciones push para cambios de estado de la orden.
* Generación de tickets digitales en formato PDF.

**4. Entregables Técnicos:**

* Genera el código estructurado por capas (Data, Domain, Presentation).
* Crea el script SQL DDL compatible con MySQL para la base de datos de respaldo.
* Define las reglas de seguridad de Firebase Firestore para proteger los datos de los clientes."

---

### 💡 Consejos adicionales para usar en Antigravity:

* **Si quieres el código:** Añade al final del prompt: *"Proporciona los archivos `main.dart`, `order_model.dart` y el script `.sql` por separado."*
* **Si buscas el diseño visual:** Añade: *"Genera un mapa de navegación (Wireframe) que conecte el Login con el Tracking de la orden."*
* **Para la base de datos:** Asegúrate de enfatizar el uso de `DECIMAL` para los precios, ya que las IAs a veces omiten esto y usan `double`, lo cual genera errores contables.
