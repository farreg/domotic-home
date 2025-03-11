#!/bin/bash

echo "Iniciando configuración del sistema domótico..."

# Verificar si .env existe
if [ ! -f .env ]; then
    echo "Creando archivo .env desde .env.example..."
    cp .env.example .env
    echo "Por favor, edita el archivo .env con tus valores personalizados"
    echo "Luego ejecuta este script nuevamente"
    exit 1
fi

# Verificar que el script de secretos existe y es ejecutable
if [ ! -x scripts/generate_secrets.sh ]; then
    echo "Dando permisos de ejecución al script de secretos..."
    chmod +x scripts/generate_secrets.sh
fi

# Generar archivos de secretos
echo "Generando archivos de secretos..."
./scripts/generate_secrets.sh

# Crear directorios necesarios
echo "Creando estructura de directorios..."
mkdir -p volumes/homeassistant
mkdir -p volumes/mosquitto/{config,log,data}
mkdir -p volumes/esphome
mkdir -p volumes/zigbee2mqtt
mkdir -p zigbee2mqtt/{data,config}

# Asegurarnos que los scripts tengan permisos de ejecución
echo "Configurando permisos de scripts..."
chmod +x mosquitto/scripts/init_mqtt.sh
chmod +x zigbee2mqtt/scripts/init_mqtt.sh
[ -f homeassistant/hacs/init_script.sh ] && chmod +x homeassistant/hacs/init_script.sh

# Copiar configuración inicial de Zigbee2MQTT
echo "Configurando Zigbee2MQTT..."
cat > zigbee2mqtt/config/configuration.yaml << EOL
homeassistant: true
permit_join: false

mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://mqtt:1883
  user: '\${MQTT_USERNAME}'
  password: '\${MQTT_PASSWORD}'

serial:
  port: '\${ZIGBEE_ADAPTER_TTY}'
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

# Comprobar si el archivo .gitignore existe
if [ ! -f .gitignore ]; then
    echo "Creando archivo .gitignore..."
    cat > .gitignore << EOF
# Ignorar directorios de datos
volumes/
secrets/
*.env

# Ignorar archivos sensibles de Zigbee2MQTT
zigbee2mqtt/data/

# Ignorar logs
*.log
EOF
    echo "Archivo .gitignore creado"
else
    # Asegurarnos de que secrets/ esté en .gitignore
    if ! grep -q "secrets/" .gitignore; then
        echo "Agregando carpeta secrets/ a .gitignore..."
        echo "secrets/" >> .gitignore
    fi
fi

echo "Configuración inicial completada."
echo "Para iniciar los servicios, ejecuta: docker-compose up -d"
echo ""
echo "IMPORTANTE: La carpeta 'secrets/' contiene información sensible."
echo "Esta carpeta NO debe ser incluida en el repositorio Git." 