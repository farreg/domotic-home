#!/bin/sh

# Script para inicializar la configuración de Mosquitto
CONFIG_DIR="/mqtt/config"
CONFIG_FILE="$CONFIG_DIR/mosquitto.conf"
PASSWD_FILE="$CONFIG_DIR/passwd"
LOG_DIR="/mqtt/log"
DATA_DIR="/mqtt/data"

echo "Iniciando configuración de Mosquitto simplificada..."

# Comprobar si los secretos están disponibles
if [ -f "/run/secrets/mqtt_username" ] && [ -f "/run/secrets/mqtt_password" ]; then
    MQTT_USERNAME=$(cat /run/secrets/mqtt_username)
    MQTT_PASSWORD=$(cat /run/secrets/mqtt_password)
    echo "Secretos de MQTT cargados correctamente"
else
    # Fallback a variables de entorno si los secretos no están disponibles
    echo "Secretos no encontrados, usando variables de entorno"
    if [ -z "$MQTT_USERNAME" ] || [ -z "$MQTT_PASSWORD" ]; then
        echo "ADVERTENCIA: Variables MQTT_USERNAME y MQTT_PASSWORD no definidas"
        echo "Se permitirán conexiones anónimas para facilitar depuración"
    fi
fi

# Crear directorios necesarios y asegurar permisos
mkdir -p "$CONFIG_DIR"
mkdir -p "$DATA_DIR"
mkdir -p "$LOG_DIR"

# Dar permisos máximos para depuración
chmod -R 777 "$CONFIG_DIR"
chmod -R 777 "$DATA_DIR"
chmod -R 777 "$LOG_DIR"

# Configuración simplificada con acceso anónimo
cat > "$CONFIG_FILE" << EOL
listener 1883
allow_anonymous true

persistence true
persistence_location $DATA_DIR/

log_dest file $LOG_DIR/mosquitto.log
log_dest stdout
EOL

chmod 644 "$CONFIG_FILE"

echo "Verificando permisos y directorios..."
ls -la "$CONFIG_DIR"
ls -la "$LOG_DIR"
ls -la "$DATA_DIR"

echo "Configuración simplificada de Mosquitto completada." 