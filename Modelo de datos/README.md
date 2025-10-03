# Marketplace - Modelo de Datos

Este proyecto define un **modelo de datos simplificado** para un marketplace pequeño con **usuarios, comerciantes, productos, órdenes, reseñas y promociones**.  
La estructura está pensada para soportar consultas rápidas típicas de un e-commerce.

---

##  Colecciones principales

- **usuarios** → clientes y vendedores.  
- **comerciantes** → tiendas o negocios que publican productos.  
- **productos** → catálogo de artículos con precios, stock y calificaciones.  
- **ordenes** → historial de compras de los usuarios.  
- **reseñas** → valoraciones y comentarios de clientes sobre productos.  
- **promociones** → descuentos activos sobre productos.

---


---

##  Consultas típicas (API REST)

- **Listar productos por etiqueta y precio máximo**  
  `GET /productos?etiqueta=deporte&precioMax=10000`

- **Ver promociones activas**  
  `GET /promociones?activo=true`

- **Historial de órdenes de un usuario**  
  `GET /usuarios/{id}/ordenes`

- **Top productos por calificación**  
  `GET /productos?sort=calificacion&limit=5`

---

