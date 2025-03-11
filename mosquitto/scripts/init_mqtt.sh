#!/bin/sh

# Script para inicializar la configuración de Mosquitto
CONFIG_DIR="/mqtt/config"
CONFIG_FILE="$CONFIG_DIR/mosquitto.conf"
PASSWD_FILE="$CONFIG_DIR/passwd"
LOG_DIR="/mqtt/log"
DATA_DIR="/mqtt/data"

echo "Iniciando configuración de Mosquitto con autenticación..."

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
        echo "Se permitirán conexiones anónimas temporalmente"
        ALLOW_ANONYMOUS="true"
    else
        ALLOW_ANONYMOUS="false"
    fi
fi

# Crear directorios necesarios y asegurar permisos
mkdir -p "$CONFIG_DIR"
mkdir -p "$DATA_DIR"
mkdir -p "$LOG_DIR"

# Dar permisos adecuados
chmod -R 777 "$CONFIG_DIR"
chmod -R 777 "$DATA_DIR"
chmod -R 777 "$LOG_DIR"

# Determinar si usar autenticación o permitir conexiones anónimas
if [ "$ALLOW_ANONYMOUS" = "true" ]; then
    # Configuración sin autenticación
    cat > "$CONFIG_FILE" << EOL
listener 1883
allow_anonymous true

persistence true
persistence_location $DATA_DIR/

log_dest file $LOG_DIR/mosquitto.log
log_dest stdout
EOL
    echo "Configurado Mosquitto para permitir conexiones anónimas"
else
    # Configuración con autenticación
    cat > "$CONFIG_FILE" << EOL
listener 1883
allow_anonymous false
password_file $PASSWD_FILE

persistence true
persistence_location $DATA_DIR/

log_dest file $LOG_DIR/mosquitto.log
log_dest stdout
EOL

    # Crear archivo de contraseñas
    echo "Creando archivo de contraseñas..."
    touch "$PASSWD_FILE"
    chmod 600 "$PASSWD_FILE"

    # Añadir usuario y contraseña
    echo "Configurando usuario y contraseña para MQTT..."
    mosquitto_passwd -b "$PASSWD_FILE" "$MQTT_USERNAME" "$MQTT_PASSWORD"
    
    # Verificar que el archivo de contraseñas se creó correctamente
    if [ ! -s "$PASSWD_FILE" ]; then
        echo "ERROR: No se pudo crear el archivo de contraseñas"
        echo "Cambiando a modo anónimo por seguridad"
        
        # Reconfigurar para modo anónimo como fallback
        cat > "$CONFIG_FILE" << EOL
listener 1883
allow_anonymous true

persistence true
persistence_location $DATA_DIR/

log_dest file $LOG_DIR/mosquitto.log
log_dest stdout
EOL
    else
        echo "Archivo de contraseñas creado exitosamente para el usuario $MQTT_USERNAME"
    fi
fi

# Asegurar permisos correctos
chmod 644 "$CONFIG_FILE"
[ -f "$PASSWD_FILE" ] && chmod 600 "$PASSWD_FILE"

echo "Verificando permisos y directorios..."
ls -la "$CONFIG_DIR"
ls -la "$LOG_DIR"
ls -la "$DATA_DIR"

echo "Configuración de Mosquitto completada." 