#!/bin/bash

echo "Iniciando configuración del sistema domótico..."

# Verificar si .env existe
if [ ! -f .env ]; then
    echo "Creando archivo .env desde .env.example..."
    cp .env.example .env
    echo "Por favor, edita el archivo .env con tus valores personalizados"
fi

# Crear directorios necesarios
echo "Creando estructura de directorios..."
mkdir -p volumes/homeassistant
mkdir -p volumes/mosquitto/{config,log,data}
mkdir -p volumes/esphome
mkdir -p zigbee2mqtt/{data,config}

# Copiar configuración inicial de Zigbee2MQTT
echo "Configurando Zigbee2MQTT..."
cat > zigbee2mqtt/config/configuration.yaml << EOL
homeassistant: true
permit_join: false

mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://mqtt:1883
  user: \${MQTT_USERNAME}
  password: \${MQTT_PASSWORD}

serial:
  port: \${ZIGBEE_ADAPTER_TTY}
  adapter: ezsp

frontend:
  port: 8080

advanced:
  log_level: debug
  network_key: GENERATE
  adapter_concurrent: 1
  adapter_delay: 100

device_options:
  legacy: false
EOL

# Dar permisos de ejecución a los scripts
echo "Configurando permisos..."
chmod +x mosquitto/scripts/init_mqtt.sh
chmod +x zigbee2mqtt/scripts/init_mqtt.sh
chmod +x homeassistant/hacs/init_script.sh

echo "Configuración inicial completada."
echo "Por favor, edita el archivo .env con tus valores personalizados antes de iniciar los servicios."
echo "Luego ejecuta: docker-compose up -d" 