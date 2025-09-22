#!/bin/bash

# --- 1. Preparación del Entorno ---

# Se define el workspace en /tmp con un nombre único por usuario para evitar conflictos.
WORKSPACE="/tmp/tp_carpetas_$USER"

# Se crea el directorio de trabajo con 'mkdir -p'. La opción -p evita errores
# si el directorio ya existe y crea directorios padres si es necesario.
echo "Preparando el entorno de trabajo en: $WORKSPACE"
mkdir -p "$WORKSPACE"

# Se cambia al directorio de trabajo. Todas las operaciones (mkdir, ls, mv, etc.)
# serán relativas a esta ruta, cumpliendo con el requisito de no salir de él.
# Si el comando 'cd' falla, el script termina con 'exit 1' para prevenir
# operaciones en un directorio incorrecto.
cd "$WORKSPACE" || exit 1

# --- Funciones Auxiliares ---

# Función para validar los nombres de carpetas ingresados por el usuario.
# Recibe el nombre como primer argumento ($1).
validar_nombre() {
    local nombre_a_validar="$1"
    
    # Se eliminan espacios en blanco al inicio y al final.
    local nombre_limpio=$(echo "$nombre_a_validar" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # Validación 1: El nombre no puede estar vacío.
    if [ -z "$nombre_limpio" ]; then
        echo "Error: El nombre de la carpeta no puede estar vacío."
        return 1 # Código de error
    fi

    # Validación 2: El nombre no puede contener '/', '..' o ser solo '.'
    # Esto previene que el usuario intente navegar o acceder a rutas absolutas.
    case "$nombre_limpio" in
        */*|..|.)
            echo "Error: El nombre contiene caracteres no válidos ('/', '..', '.') o es una ruta."
            return 1 # Código de error
            ;;
    esac
    
    # Si pasa todas las validaciones, retorna éxito.
    return 0
}

# --- 2. Menú Principal ---

# Se inicia un bucle 'while true' para que el menú se muestre continuamente
# hasta que el usuario elija la opción de salir.
while true; do
    # Se limpia la pantalla para una mejor presentación del menú en cada iteración.
    clear
    echo "=================================================="
    echo "    GESTOR DE CARPETAS EN EL WORKSPACE"
    echo "    Directorio actual: $PWD"
    echo "=================================================="
    echo "1) Crear una carpeta"
    echo "2) Listar carpetas existentes"
    echo "3) Renombrar una carpeta"
    echo "4) Eliminar una carpeta"
    echo "5) SALIR"
    echo "--------------------------------------------------"

    read -p "Seleccione una opción [1-5]: " opcion

    # Se usa 'case' para evaluar la opción elegida por el usuario.
    case $opcion in
        1) # Crear carpeta
            echo -e "\n--- Crear Carpeta ---"
            read -p "Ingrese el nombre de la nueva carpeta: " nombre_nuevo
            nombre_limpio=$(echo "$nombre_nuevo" | sed 's/^[ \t]*//;s/[ \t]*$//')

            if validar_nombre "$nombre_limpio"; then
                if [ -d "$nombre_limpio" ]; then
                    echo "Aviso: La carpeta '$nombre_limpio' ya existe. No se ha creado nada."
                else
                    mkdir "$nombre_limpio"
                    echo "Éxito: Carpeta '$nombre_limpio' creada correctamente."
                fi
            fi
            ;;

        2) # Listar carpetas
            echo -e "\n--- Listado de Carpetas ---"
            # Se usa 'find' para buscar solo directorios (-type d) en el nivel actual
            # (-maxdepth 1) y se excluye el propio directorio '.' (-mindepth 1).
            # Es más seguro que 'ls' si hay nombres con espacios o caracteres especiales.
            # Se comprueba si la salida de find no está vacía antes de listar.
            if [ -n "$(find . -maxdepth 1 -mindepth 1 -type d)" ]; then
                find . -maxdepth 1 -mindepth 1 -type d | sed 's|^\./||' | sort
            else
                echo "No hay carpetas en este workspace."
            fi
            ;;

        3) # Renombrar carpeta
            echo -e "\n--- Renombrar Carpeta ---"
            read -p "Nombre actual de la carpeta: " origen
            read -p "Nuevo nombre para la carpeta: " destino
            origen_limpio=$(echo "$origen" | sed 's/^[ \t]*//;s/[ \t]*$//')
            destino_limpio=$(echo "$destino" | sed 's/^[ \t]*//;s/[ \t]*$//')

            # Se valida tanto el nombre de origen como el de destino.
            if validar_nombre "$origen_limpio" && validar_nombre "$destino_limpio"; then
                if [ ! -d "$origen_limpio" ]; then
                    echo "Error: La carpeta de origen '$origen_limpio' no existe."
                elif [ -e "$destino_limpio" ]; then
                    echo "Error: El nombre de destino '$destino_limpio' ya está en uso."
                else
                    mv "$origen_limpio" "$destino_limpio"
                    echo "Éxito: La carpeta '$origen_limpio' fue renombrada a '$destino_limpio'."
                fi
            fi
            ;;

        4) # Eliminar carpeta
            echo -e "\n--- Eliminar Carpeta ---"
            read -p "Nombre de la carpeta a eliminar: " nombre_a_borrar
            nombre_limpio=$(echo "$nombre_a_borrar" | sed 's/^[ \t]*//;s/[ \t]*$//')

            if validar_nombre "$nombre_limpio"; then
                if [ ! -d "$nombre_limpio" ]; then
                    echo "Error: La carpeta '$nombre_limpio' no existe."
                else
                    # Se intenta borrar con 'rmdir', que solo funciona si la carpeta está vacía.
                    # Es una primera medida de seguridad. Se redirige el error a /dev/null.
                    if rmdir "$nombre_limpio" 2>/dev/null; then
                        echo "Éxito: La carpeta vacía '$nombre_limpio' ha sido eliminada."
                    else
                        # Si 'rmdir' falla, significa que la carpeta no está vacía.
                        echo "Aviso: La carpeta '$nombre_limpio' no está vacía."
                        read -p "¿Desea forzar la eliminación (esto borrará todo su contenido)? (S/N): " confirmacion
                        if [[ "$confirmacion" == "S" || "$confirmacion" == "s" ]]; then
                            # 'rm -r' elimina la carpeta y todo su contenido recursivamente.
                            rm -r "$nombre_limpio"
                            echo "Éxito: La carpeta '$nombre_limpio' y todo su contenido han sido eliminados."
                        else
                            echo "Operación de borrado cancelada por el usuario."
                        fi
                    fi
                fi
            fi
            ;;

        5) # SALIR
            echo -e "\nSaliendo del gestor de carpetas. ¡Hasta luego!"
            break # Rompe el bucle 'while' y permite que el script termine.
            ;;

        *) # Opción no válida
            echo -e "\nError: Opción no válida. Por favor, elija un número del 1 al 5."
            ;;
    esac

    # Pequeña pausa para que el usuario pueda leer el resultado de la operación
    # antes de que el bucle vuelva a empezar y se limpie la pantalla.
    echo ""
    read -p "Presione Enter para continuar..."
done

# --- Fin del Script ---
exit 0