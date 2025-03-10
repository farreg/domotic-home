# domotic-home

Un proyecto de domótica basado en Home Assistant para automatizar y controlar dispositivos en el hogar.

## Componentes

- **Home Assistant**: Plataforma principal de domótica (versión latest)
- **MQTT (Mosquitto)**: Broker para comunicación entre dispositivos
- **HACS**: Home Assistant Community Store para instalar integraciones adicionales

## Requisitos

- Docker y Docker Compose
- Variables de entorno:
  - `HA_CONFIG_PATH`: Directorio para configuración de Home Assistant
  - `MQTT_CONFIG_PATH`: Directorio para configuración de MQTT
  - `MQTT_LOG_PATH`: Directorio para logs de MQTT
  - `MQTT_DATA_PATH`: Directorio para datos de MQTT
  - `HA_GITHUB_TOKEN`: Token de GitHub para HACS

## Instalación

1. Clonar el repositorio
2. Configurar las variables de entorno
3. Ejecutar `docker-compose up -d`