#!/bin/sh

# Script para asegurar que la configuración de MQTT sea correcta
# Este script se ejecutará al inicio del contenedor Zigbee2MQTT

CONFIG_FILE="/app/data/configuration.yaml"

echo "Iniciando script de configuración de Zigbee2MQTT..."

# Asegurarse de que estamos usando la configuración correcta de MQTT
if [ -f "$CONFIG_FILE" ]; then
    echo "Verificando configuración MQTT..."
    
    # Comprueba si existe la variable de entorno MQTT_SERVER 
    if [ ! -z "$MQTT_SERVER" ]; then
        echo "Actualizando servidor MQTT a $MQTT_SERVER"
        
        # Reemplaza la línea del servidor MQTT en el archivo de configuración
        sed -i "s|server:.*|server: $MQTT_SERVER|g" "$CONFIG_FILE"
        
        echo "Configuración MQTT actualizada correctamente"
    else
        echo "Variable MQTT_SERVER no definida, usando configuración existente"
    fi
else
    echo "Archivo de configuración no encontrado: $CONFIG_FILE"
    exit 1
fi

echo "Iniciando Zigbee2MQTT..."
# Ejecutar el comando original de inicio
node index.js 