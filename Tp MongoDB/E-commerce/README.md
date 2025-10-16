# E-commerce MongoDB - Informe

## Resumen

Base de datos MongoDB para e-commerce con 6 colecciones, 9 índices, transacciones, soft delete, búsqueda full-text y auditoría.

---

## Colecciones

| Colección | Documentos | Descripción |
|-----------|-----------|-------------|
| categorias | 3 | Categorías de productos |
| productos | 3 (2 activos) | Catálogo con soft delete |
| usuarios | 3 | Clientes y administradores |
| pedidos | 2 | Órdenes con items anidados |
| comentarios | 2 | Reseñas de productos |
| auditoria | 1 | Registro de cambios |

---

## Validaciones

Todas las colecciones tienen JSON Schema con:
- Campos obligatorios
- Tipos BSON estrictos
- Restricciones de rango (min/max, length)
- Valores enum

**Ejemplo - Productos:**
```
nombre: string (3-100 caracteres) - OBLIGATORIO
precio: double (mínimo 0.01) - OBLIGATORIO
stock: integer (mínimo 0) - OBLIGATORIO
rating: double o int (0-5)
eliminado: boolean (para soft delete)
```

---

## Índices (9 total)

| Colección | Nombre | Tipo |
|-----------|--------|------|
| usuarios | idx_email_unico | UNIQUE |
| productos | idx_productos_categoria_activo | COMPOUND |
| productos | idx_texto_productos | TEXT (full-text) |
| productos | idx_productos_activos | PARTIAL (solo activos) |
| pedidos | idx_pedidos_usuario_estado | COMPOUND |
| pedidos | idx_pedidos_estado | SIMPLE |
| pedidos | idx_pedidos_fecha_desc | SIMPLE |
| comentarios | idx_comentarios_unico | UNIQUE COMPOUND |
| categorias | idx_categoria_nombre | SIMPLE |

---

## Relaciones

- Usuario → Pedidos: 1:N
- Producto → Comentarios: 1:N
- Usuario → Comentarios: 1:N
- Producto ↔ Categorías: N:M (array en producto)
- Pedido → Productos: N:M (items array)

---

## Características

✓ **Transacciones ACID:** Crear pedido + descontar stock  
✓ **Vista materializada:** `pedidosDetallado` (3-way join)  
✓ **Soft Delete:** Productos marcados como `eliminado: true`  
✓ **Búsqueda full-text:** Índice en nombre + descripción con ranking  
✓ **Usuario solo lectura:** `lector` con rol `read` en ecommerce  
✓ **Change Stream:** Tabla auditoria registra cambios  
✓ **Exportación:** JSONL y BSON generados automáticamente  

---

## Verificación en MongoDB Compass

1. **Indexes:** productos → pestaña Indexes (muestra 4 índices)
2. **Validation:** productos → pestaña Validation (muestra JSON Schema)
3. **Soft Delete:** productos → filtro `{ eliminado: true }` (encuentra Mouse)
4. **Vista:** pedidosDetallado (muestra datos con usuario y productos)

---

## Queries Básicas

```javascript
// Productos activos
db.productos.find({ eliminado: false, activo: true })

// Búsqueda full-text
db.productos.find({ $text: { $search: "laptop" } })

// Pedidos con usuario
db.pedidos.aggregate([
  { $lookup: { from: "usuarios", localField: "usuarioId", foreignField: "_id", as: "usuario" } },
  { $unwind: "$usuario" }
])

// Vista con datos completos
db.pedidosDetallado.find()
```

---

## Archivos Generados

```
script1.sh          # Script setup
exports/usuarios.jsonl
exports/productos.jsonl
exports/pedidos.jsonl
backups/            # Backups BSON
```

---

## Stack

- MongoDB 8.2.1
- Mongosh 2.5.8
- Conexión: localhost:27017

---

## Checklist

- [x] 5 colecciones + 1 vista
- [x] JSON Schema validación
- [x] 9 índices optimizados
- [x] Relaciones N:1, 1:N, N:M
- [x] Transacciones ACID
- [x] Soft delete
- [x] Full-text search
- [x] Usuario read-only
- [x] Change Stream
- [x] Exportación JSONL/BSON
- [x] Verificado en Compass

**Estado:** Completado ✓