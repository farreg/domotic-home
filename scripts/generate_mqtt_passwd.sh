#!/bin/bash

# Este script genera el archivo de contraseñas para Mosquitto
# usando las credenciales definidas en el archivo .env

# Cargar variables de entorno
if [ -f ../.env ]; then
  source ../.env
else
  echo "Error: No se encontró el archivo .env"
  exit 1
fi

# Verificar que las variables necesarias estén definidas
if [ -z "$MQTT_USERNAME" ] || [ -z "$MQTT_PASSWORD" ]; then
  echo "Error: Las variables MQTT_USERNAME y MQTT_PASSWORD deben estar definidas en el archivo .env"
  exit 1
fi

# Crear directorio de configuración si no existe
CONFIG_DIR="../volumes/mosquitto/config"
mkdir -p $CONFIG_DIR

# Crear el archivo de contraseñas
echo "Generando archivo de contraseñas para Mosquitto..."

# Si ya existe un contenedor de mosquitto, usar el comando dentro del contenedor
if docker ps | grep -q mosquitto; then
  docker exec mosquitto mosquitto_passwd -c /mqtt/config/passwd "$MQTT_USERNAME" "$MQTT_PASSWORD"
  echo "Archivo de contraseñas generado usando el contenedor de Mosquitto."
else
  # Si no hay contenedor, mostrar instrucciones
  echo "El contenedor de Mosquitto no está en ejecución."
  echo ""
  echo "Para generar el archivo de contraseñas, ejecuta los siguientes comandos"
  echo "después de levantar los contenedores:"
  echo ""
  echo "docker exec mosquitto mosquitto_passwd -c /mqtt/config/passwd $MQTT_USERNAME"
  echo ""
  echo "Se te pedirá ingresar la contraseña dos veces."
fi

echo ""
echo "Recuerda que Zigbee2MQTT y Home Assistant necesitarán actualizarse"
echo "para usar estas credenciales de MQTT." 