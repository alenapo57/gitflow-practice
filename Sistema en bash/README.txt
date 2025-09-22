Este repositorio contiene un script de BASH para gestionar directorios de forma segura.

El script 'menu_carpetas.sh' crea un menú interactivo que opera exclusivamente
dentro de un workspace temporal y aislado en '/tmp/tp_carpetas_$USER'.
Para la creación y renombrado se usan 'mkdir' y 'mv', respectivamente.
El listado se realiza con 'find . -maxdepth 1 -type d' por su fiabilidad al
mostrar únicamente directorios, evitando archivos u otros elementos.
Para eliminar, se prioriza la seguridad usando 'rmdir' (solo borra carpetas vacías).
Si la carpeta no está vacía, se ofrece la opción de borrado forzado con 'rm -r'.
La lógica del menú está construida con un bucle 'while' y una estructura 'case',
y las validaciones de entrada previenen el uso de rutas para mayor seguridad.