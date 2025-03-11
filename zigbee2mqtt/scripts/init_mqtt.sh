#!/bin/sh

# Script para configurar Zigbee2MQTT
CONFIG_FILE="/app/data/configuration.yaml"
CONFIG_TEMPLATE="/app/config/configuration.yaml"

echo "Iniciando script de configuración de Zigbee2MQTT..."

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

# Asegurar que los directorios existan y tengan permisos adecuados
mkdir -p "$(dirname "$CONFIG_FILE")"
chmod -R 777 "/app/data"

# Copiar configuración de plantilla si no existe
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuración no encontrada, copiando plantilla..."
    cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
    chmod 644 "$CONFIG_FILE"
fi

# Asegurarse de que estamos usando la configuración correcta de MQTT
if [ -f "$CONFIG_FILE" ]; then
    echo "Actualizando configuración MQTT..."
    
    # Reemplazar las variables en el archivo de configuración
    sed -i "s/user: '\${MQTT_USERNAME}'/user: '$MQTT_USERNAME'/g" "$CONFIG_FILE"
    sed -i "s/password: '\${MQTT_PASSWORD}'/password: '$MQTT_PASSWORD'/g" "$CONFIG_FILE"
    
    # Reemplazar la ruta del adaptador si está definida
    if [ ! -z "$ZIGBEE_ADAPTER_TTY" ]; then
        echo "Configurando adaptador Zigbee: $ZIGBEE_ADAPTER_TTY"
        sed -i "s|port: '\${ZIGBEE_ADAPTER_TTY}'|port: '$ZIGBEE_ADAPTER_TTY'|g" "$CONFIG_FILE"
        
        # Asegurar que el dispositivo tenga permisos adecuados
        if [ -e "$ZIGBEE_ADAPTER_TTY" ]; then
            chmod 666 "$ZIGBEE_ADAPTER_TTY"
        fi
    fi
    
    # Configurar servidor MQTT si está definido
    if [ ! -z "$MQTT_SERVER" ]; then
        echo "Configurando servidor MQTT: $MQTT_SERVER"
        sed -i "s|server: mqtt://mqtt:1883|server: $MQTT_SERVER|g" "$CONFIG_FILE"
    fi
    
    echo "Configuración MQTT actualizada correctamente"
else
    echo "ERROR: Archivo de configuración no encontrado: $CONFIG_FILE"
    exit 1
fi

# Esperar a que el servidor MQTT esté disponible
echo "Esperando a que el servidor MQTT esté disponible..."
for i in $(seq 1 30); do
    if nc -z mqtt 1883; then
        echo "Servidor MQTT disponible, continuando..."
        break
    fi
    echo "Esperando al servidor MQTT... intento $i/30"
    sleep 2
    if [ $i -eq 30 ]; then
        echo "ERROR: No se pudo conectar al servidor MQTT después de 60 segundos"
        echo "Continuando de todos modos..."
    fi
done

echo "Iniciando Zigbee2MQTT..."
# Ejecutar el comando original de inicio
node index.js 