#!/bin/bash
# -------------------------------------------------------------
# Script: setup_myapp.sh
# Descripción: Conecta a MongoDB y crea la base de datos myapp 
# con todas las colecciones, documentos e índices.
# -------------------------------------------------------------

# Ruta a mongosh (ajustar si está en otra carpeta)
MONGOSH_PATH="C:/mongodb/Tools/mongosh/mongosh.exe"

# Verifica si mongosh existe
if [ ! -f "$MONGOSH_PATH" ]; then
  echo "❌ No se encontró mongosh en $MONGOSH_PATH"
  echo "Editá la variable MONGOSH_PATH para indicar la ruta correcta."
  exit 1
fi

# Ejecuta los comandos en MongoDB
"$MONGOSH_PATH" <<'EOF'
use myapp

db.categories.insertMany([
  { name: "Electrónica", slug: "electro" },
  { name: "Gaming", slug: "gaming" },
  { name: "Hogar", slug: "hogar" }
])

db.users.insertOne({
  username: "usuario_vip",
  email: "vip@tienda.com",
  role: "admin",
  registered_at: new Date()
})

db.products.insertOne({
  name: "Mouse Pro",
  price: 50.00,
  stock: 20
})

db.reviews.insertMany([
  {
    product_id: db.products.findOne({ name: "Mouse Pro" })._id,
    user_id: db.users.findOne({ username: "usuario_vip" })._id,
    rating: 5,
    comment: "Excelente mouse para gaming y trabajo.",
    date: new Date()
  },
  {
    product_id: db.products.findOne({ name: "Mouse Pro" })._id,
    user_id: db.users.findOne({ username: "usuario_vip" })._id,
    rating: 4,
    comment: "Buen producto, llego a tiempo.",
    date: new Date()
  }
])

db.orders.insertOne({
  user_id: db.users.findOne({ username: "usuario_vip" })._id,
  date: new Date(),
  status: "pending",
  total_amount: 50.00,
  items: [
    { product_id: db.products.findOne({ name: "Mouse Pro" })._id, quantity: 1, price_at_purchase: 50.00 }
  ]
})

db.users.createIndex({ email: 1 }, { unique: true })
db.orders.createIndex({ user_id: 1 })
db.reviews.createIndex({ product_id: 1 })

db.runCommand({
  collMod: "products",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "price", "stock"],
      properties: {
        price: {
          bsonType: "number",
          minimum: 0,
          description: "El precio debe ser un número positivo."
        },
        stock: {
          bsonType: "int",
          minimum: 0,
          description: "El stock debe ser un número entero no negativo."
        }
      }
    }
  },
  validationAction: "error"
})

show collections
db.orders.find().pretty()
db.reviews.find().pretty()
EOF