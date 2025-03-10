# domotic-home

Un proyecto de domótica basado en Home Assistant para automatizar y controlar dispositivos en el hogar, optimizado para Raspberry Pi 4 con adaptador Sonoff Zigbee USB.

## Componentes

- **Home Assistant**: Plataforma principal de domótica (versión latest)
- **Zigbee2MQTT**: Para gestionar dispositivos Zigbee a través del adaptador Sonoff
- **ESPHome**: Para programar y gestionar dispositivos basados en ESP8266/ESP32
- **MQTT (Mosquitto)**: Broker para comunicación entre dispositivos con autenticación segura
- **HACS**: Home Assistant Community Store para instalar integraciones adicionales

## Características

- **Seguridad**: Autenticación MQTT, limitación de conexiones
- **Temas personalizados**: Incluye tema oscuro predeterminado
- **Scripts de automatización**: Instalación de HACS y detección de adaptadores Zigbee
- **Configuración predefinida**: Automaciones, scripts y escenas de ejemplo

## Requisitos

- Raspberry Pi 4 (recomendado 4GB+ RAM)
- Adaptador Sonoff Zigbee USB
- Docker y Docker Compose
- Variables de entorno:
  - `HA_CONFIG_PATH`: Directorio para configuración de Home Assistant
  - `MQTT_CONFIG_PATH`: Directorio para configuración de MQTT
  - `MQTT_LOG_PATH`: Directorio para logs de MQTT
  - `MQTT_DATA_PATH`: Directorio para datos de MQTT
  - `ZIGBEE2MQTT_DATA`: Directorio para datos de Zigbee2MQTT
  - `ESPHOME_CONFIG`: Directorio para configuración de ESPHome
  - `HA_GITHUB_TOKEN`: Token de GitHub para HACS
  - `MQTT_USERNAME`: Usuario para autenticación MQTT
  - `MQTT_PASSWORD`: Contraseña para autenticación MQTT

## Instalación

1. Clonar el repositorio
2. Configurar las variables de entorno en un archivo `.env` (usar `.env.example` como referencia)
3. Conectar el adaptador Sonoff Zigbee USB a la Raspberry Pi
4. Ejecutar `docker-compose up -d`
5. Generar el archivo de contraseñas para MQTT:
   ```
   cd scripts
   ./generate_mqtt_passwd.sh
   cd ..
   docker-compose restart mqtt
   ```
6. Configurar automáticamente el adaptador Zigbee:
   ```
   cd scripts
   ./configure_zigbee.sh
   cd ..
   docker-compose restart zigbee2mqtt
   ```
7. Acceder a los servicios:
   - Home Assistant: `http://[IP-RASPBERRY]:8123`
   - Zigbee2MQTT: `http://[IP-RASPBERRY]:8080`
   - ESPHome: `http://[IP-RASPBERRY]:6052`

## Seguridad

Este proyecto implementa seguridad básica con autenticación MQTT. Se recomienda:

- Usar contraseñas fuertes para MQTT
- Cambiar regularmente las contraseñas
- Asegurar la red donde se encuentra la Raspberry Pi

## Recomendaciones para Raspberry Pi

- Usar una tarjeta SD de alta calidad (clase 10 o superior) o preferiblemente un SSD USB
- Asegurar que la Raspberry Pi tenga buena ventilación
- Realizar copias de seguridad periódicas con la función de snapshots de Home Assistant