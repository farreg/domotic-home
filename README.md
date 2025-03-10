# domotic-home

Un proyecto de domótica basado en Home Assistant para automatizar y controlar dispositivos en el hogar, optimizado para Raspberry Pi 4 con adaptador Sonoff Zigbee USB.

## Componentes

- **Home Assistant**: Plataforma principal de domótica (versión latest)
- **Zigbee2MQTT**: Para gestionar dispositivos Zigbee a través del adaptador Sonoff
- **ESPHome**: Para programar y gestionar dispositivos basados en ESP8266/ESP32
- **MQTT (Mosquitto)**: Broker para comunicación entre dispositivos
- **HACS**: Home Assistant Community Store para instalar integraciones adicionales

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

## Instalación

1. Clonar el repositorio
2. Configurar las variables de entorno en un archivo `.env`
3. Conectar el adaptador Sonoff Zigbee USB a la Raspberry Pi
4. Ejecutar `docker-compose up -d`
5. Acceder a los servicios:
   - Home Assistant: `http://[IP-RASPBERRY]:8123`
   - Zigbee2MQTT: `http://[IP-RASPBERRY]:8080`
   - ESPHome: `http://[IP-RASPBERRY]:6052`

## Recomendaciones para Raspberry Pi

- Usar una tarjeta SD de alta calidad (clase 10 o superior) o preferiblemente un SSD USB
- Asegurar que la Raspberry Pi tenga buena ventilación
- Realizar copias de seguridad periódicas con la función de snapshots de Home Assistant