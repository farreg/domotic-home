#!/bin/sh

# Script para inicializar la configuración de Mosquitto
CONFIG_DIR="/mqtt/config"
CONFIG_FILE="$CONFIG_DIR/mosquitto.conf"
PASSWD_FILE="$CONFIG_DIR/passwd"

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

# Crear directorios necesarios
mkdir -p "$CONFIG_DIR"
mkdir -p "/mqtt/data"
mkdir -p "/mqtt/log"

# Crear archivo de configuración
cat > "$CONFIG_FILE" << EOL
listener 1883
allow_anonymous false
password_file $PASSWD_FILE

persistence true
persistence_location /mqtt/data/

log_dest file /mqtt/log/mosquitto.log
log_dest stdout
EOL

# Crear archivo de contraseñas si no existe
if [ ! -f "$PASSWD_FILE" ]; then
    echo "Creando archivo de contraseñas..."
    touch "$PASSWD_FILE"
    mosquitto_passwd -b "$PASSWD_FILE" "$MQTT_USERNAME" "$MQTT_PASSWORD"
    echo "Archivo de contraseñas creado para el usuario $MQTT_USERNAME"
else
    echo "Actualizando archivo de contraseñas..."
    mosquitto_passwd -b "$PASSWD_FILE" "$MQTT_USERNAME" "$MQTT_PASSWORD"
    echo "Contraseña actualizada para el usuario $MQTT_USERNAME"
fi

# Asegurar permisos correctos
chmod 644 "$CONFIG_FILE"
chmod 600 "$PASSWD_FILE"

echo "Configuración de Mosquitto completada." 