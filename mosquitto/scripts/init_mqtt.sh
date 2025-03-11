#!/bin/sh

# Script para inicializar la configuración de Mosquitto
CONFIG_DIR="/mqtt/config"
CONFIG_FILE="$CONFIG_DIR/mosquitto.conf"
LOG_DIR="/mqtt/log"
DATA_DIR="/mqtt/data"

echo "Iniciando configuración de Mosquitto simplificada..."

# Crear directorios necesarios y asegurar permisos
mkdir -p "$CONFIG_DIR"
mkdir -p "$DATA_DIR"
mkdir -p "$LOG_DIR"

# Dar permisos máximos para depuración
chmod -R 777 "$CONFIG_DIR"
chmod -R 777 "$DATA_DIR"
chmod -R 777 "$LOG_DIR"

# Crear archivo de configuración simplificado
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