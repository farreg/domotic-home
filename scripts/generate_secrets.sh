#!/bin/bash

# Script para generar archivos de secretos

SECRETS_DIR="./secrets"
ENV_FILE=".env"

echo "Generando archivos de secretos para Docker..."

# Crear directorio de secretos si no existe
mkdir -p "$SECRETS_DIR"

# Verificar si .env existe
if [ ! -f "$ENV_FILE" ]; then
    echo "Archivo .env no encontrado. Creando uno básico..."
    cp .env.example "$ENV_FILE"
    echo "Por favor edita el archivo .env antes de continuar."
    exit 1
fi

# Extraer variables del archivo .env
echo "Leyendo variables de $ENV_FILE..."
source "$ENV_FILE"

# Verificar variables requeridas
if [ -z "$MQTT_USERNAME" ] || [ -z "$MQTT_PASSWORD" ]; then
    echo "ERROR: Variables MQTT_USERNAME o MQTT_PASSWORD no definidas en $ENV_FILE"
    echo "Por favor, edita el archivo $ENV_FILE y ejecuta este script nuevamente."
    exit 1
fi

# Generar archivos de secretos
echo "Generando archivos de secretos..."

# MQTT Username
echo -n "$MQTT_USERNAME" > "$SECRETS_DIR/mqtt_username.txt"
echo "Creado $SECRETS_DIR/mqtt_username.txt"

# MQTT Password
echo -n "$MQTT_PASSWORD" > "$SECRETS_DIR/mqtt_password.txt"
echo "Creado $SECRETS_DIR/mqtt_password.txt"

# GitHub Token (si existe)
if [ ! -z "$HA_GITHUB_TOKEN" ]; then
    echo -n "$HA_GITHUB_TOKEN" > "$SECRETS_DIR/ha_github_token.txt"
    echo "Creado $SECRETS_DIR/ha_github_token.txt"
else
    echo "ADVERTENCIA: HA_GITHUB_TOKEN no definido en $ENV_FILE"
    echo "Creando un token vacío. Deberás actualizarlo manualmente."
    echo -n "" > "$SECRETS_DIR/ha_github_token.txt"
    echo "Creado $SECRETS_DIR/ha_github_token.txt (vacío)"
fi

# Establecer permisos restrictivos
chmod -R 600 "$SECRETS_DIR"/*
echo "Permisos de archivos establecidos a 600 (solo lectura/escritura para el propietario)"

echo "Archivos de secretos generados correctamente en $SECRETS_DIR/"
echo "IMPORTANTE: No incluyas la carpeta $SECRETS_DIR en tu repositorio Git."
echo "Estos archivos contienen información sensible y deben permanecer seguros." 