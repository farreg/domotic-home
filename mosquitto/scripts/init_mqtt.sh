#!/bin/sh

# Script para inicializar la configuración de Mosquitto
CONFIG_DIR="/mqtt/config"
CONFIG_FILE="$CONFIG_DIR/mosquitto.conf"
PASSWD_FILE="$CONFIG_DIR/passwd"
LOG_DIR="/mqtt/log"
DATA_DIR="/mqtt/data"

echo "Iniciando configuración de Mosquitto..."

# Comprobar si los secretos están disponibles
if [ -f "/run/secrets/mqtt_username" ] && [ -f "/run/secrets/mqtt_password" ]; then
    MQTT_USERNAME=$(cat /run/secrets/mqtt_username)
    MQTT_PASSWORD=$(cat /run/secrets/mqtt_password)
    echo "Secretos de MQTT cargados correctamente"
else
    # Fallback a variables de entorno si los secretos no están disponibles
    echo "Secretos no encontrados, usando variables de entorno"
    if [ -z "$MQTT_USERNAME" ] || [ -z "$MQTT_PASSWORD" ]; then
        echo "ERROR: Variables MQTT_USERNAME y MQTT_PASSWORD no definidas"
        echo "Por favor, crea el archivo de secretos en ./secrets/ o define las variables de entorno"
        exit 1
    fi
fi

# Crear directorios necesarios y asegurar permisos
mkdir -p "$CONFIG_DIR"
mkdir -p "$DATA_DIR"
mkdir -p "$LOG_DIR"

# Asegurar que los directorios tengan permisos de escritura
chmod -R 777 "$CONFIG_DIR"
chmod -R 777 "$DATA_DIR"
chmod -R 777 "$LOG_DIR"

# Crear archivo de configuración
cat > "$CONFIG_FILE" << EOL
listener 1883
allow_anonymous false
password_file $PASSWD_FILE

persistence true
persistence_location $DATA_DIR/

log_dest file $LOG_DIR/mosquitto.log
log_dest stdout
EOL

# Asegurar permisos correctos para el archivo de configuración
chmod 644 "$CONFIG_FILE"

# Crear archivo de contraseñas
echo "Creando archivo de contraseñas..."
touch "$PASSWD_FILE"
chmod 600 "$PASSWD_FILE"

# Añadir usuario y contraseña
echo "Actualizando archivo de contraseñas..."
mosquitto_passwd -b "$PASSWD_FILE" "$MQTT_USERNAME" "$MQTT_PASSWORD"
echo "Contraseña actualizada para el usuario $MQTT_USERNAME"

# Verificar que el archivo de contraseñas existe y tiene el contenido correcto
if [ ! -s "$PASSWD_FILE" ]; then
    echo "ERROR: El archivo de contraseñas está vacío o no se pudo crear"
    # Crear manualmente el archivo de contraseñas con un formato básico
    echo "$MQTT_USERNAME:$MQTT_PASSWORD" > "$PASSWD_FILE"
    echo "Creado archivo de contraseñas básico como fallback"
fi

# Asegurar permisos correctos para los archivos
chmod 644 "$CONFIG_FILE"
chmod 600 "$PASSWD_FILE"

# Verificar permisos
ls -la "$CONFIG_DIR"
ls -la "$LOG_DIR"
ls -la "$DATA_DIR"

echo "Configuración de Mosquitto completada." 