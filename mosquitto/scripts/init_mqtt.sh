#!/bin/sh

# Script para inicializar la configuración de Mosquitto
CONFIG_DIR="/mqtt/config"
CONFIG_FILE="$CONFIG_DIR/mosquitto.conf"
PASSWD_FILE="$CONFIG_DIR/passwd"

echo "Iniciando configuración de Mosquitto..."

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
fi

# Asegurar permisos correctos
chmod 644 "$CONFIG_FILE"
chmod 600 "$PASSWD_FILE"

echo "Configuración de Mosquitto completada." 