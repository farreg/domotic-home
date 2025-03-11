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
- **Configuración predefinida**: Ejemplos educativos de automaciones, scripts y escenas
- **Detección automática**: Soporte para diferentes tipos de adaptadores Zigbee USB

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
  - `ZIGBEE_ADAPTER_TTY`: Ruta al dispositivo del adaptador Zigbee (ej. `/dev/ttyACM0` o `/dev/ttyUSB0`)

## Instalación

### Método 1: Instalación automatizada (recomendado)

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/farreg/domotic-home.git
   cd domotic-home
   ```

2. Ejecutar el script de configuración:
   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

3. Editar el archivo `.env` con tus valores personalizados
   ```bash
   nano .env
   ```

4. Ejecutar el script de configuración nuevamente para generar los secretos:
   ```bash
   ./scripts/setup.sh
   ```

5. Iniciar los servicios:
   ```bash
   docker-compose up -d
   ```

### Método 2: Instalación manual

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/farreg/domotic-home.git
   cd domotic-home
   ```

2. Copiar el archivo `.env.example` a `.env` y editar con tus valores:
   ```bash
   cp .env.example .env
   nano .env
   ```

3. Crear la estructura de directorios:
   ```bash
   mkdir -p volumes/homeassistant
   mkdir -p volumes/mosquitto/{config,log,data}
   mkdir -p volumes/esphome
   mkdir -p zigbee2mqtt/{data,config}
   mkdir -p secrets
   ```

4. Generar los archivos de secretos:
   ```bash
   chmod +x scripts/generate_secrets.sh
   ./scripts/generate_secrets.sh
   ```

5. Dar permisos de ejecución a los scripts:
   ```bash
   chmod +x mosquitto/scripts/init_mqtt.sh
   chmod +x zigbee2mqtt/scripts/init_mqtt.sh
   chmod +x homeassistant/hacs/init_script.sh
   ```

6. Iniciar los servicios:
   ```bash
   docker-compose up -d
   ```

### Actualización

Para actualizar la instalación existente:

1. Obtener los últimos cambios:
   ```bash
   git pull origin main
   ```

2. Actualizar secretos (si se han añadido nuevos):
   ```bash
   ./scripts/generate_secrets.sh
   ```

3. Reiniciar los servicios:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

## Seguridad

Este proyecto implementa varias medidas de seguridad:

- **Autenticación MQTT**: Protección con usuario y contraseña
- **Ejemplos genéricos**: Los archivos de automatizaciones, escenas y scripts contienen solo ejemplos educativos sin información personal
- **Configuración privada**: Se recomienda crear tus automatizaciones personalizadas directamente en la interfaz de Home Assistant

Recomendaciones adicionales:
- Usar contraseñas fuertes para MQTT
- Cambiar regularmente las contraseñas
- Asegurar la red donde se encuentra la Raspberry Pi
- NO almacenar información sensible en repositorios públicos

## Gestión de datos y backups

Este repositorio está configurado para excluir datos sensibles mediante .gitignore:

- **Archivos de configuración**: El archivo `.env` con credenciales no se almacena en el repositorio
- **Datos de dispositivos**: La información de dispositivos Zigbee y sus claves está excluida
- **Logs y bases de datos**: Los archivos de registro y bases de datos están excluidos

Para realizar copias de seguridad de forma segura:

1. **Configuración de Home Assistant**:
   ```bash
   # Copia de seguridad de configuración, excluyendo datos sensibles
   tar --exclude='.storage' --exclude='secrets.yaml' -czvf ha_config_backup.tar.gz ./volumes/homeassistant
   ```

2. **Backup completo desde Home Assistant**:
   - Usa la función de "Snapshots" nativa de Home Assistant
   - Almacena estos backups en un lugar seguro, fuera del repositorio

3. **Claves Zigbee**:
   ```bash
   # Copia de seguridad de datos Zigbee (importante para preservar emparejamientos)
   tar -czvf zigbee_data_backup.tar.gz ./zigbee2mqtt/data
   ```

## Recomendaciones para Raspberry Pi

- Usar una tarjeta SD de alta calidad (clase 10 o superior) o preferiblemente un SSD USB
- Asegurar que la Raspberry Pi tenga buena ventilación
- Realizar copias de seguridad periódicas con la función de snapshots de Home Assistant

## Solución de problemas con adaptadores Zigbee

Si encuentras problemas con la detección automática del adaptador Zigbee:

1. **Verificar la conexión física**: Asegúrate de que el adaptador esté correctamente conectado
2. **Identificar manualmente el adaptador**:
   ```bash
   ls -l /dev/ttyUSB*
   ls -l /dev/ttyACM*
   dmesg | grep -i tty
   ```
3. **Configurar manualmente**:
   - Edita el archivo `.env` y establece `ZIGBEE_ADAPTER_TTY` a la ruta correcta
   - Reinicia los servicios: `docker-compose down && docker-compose up -d`
4. **Permisos de dispositivo**: Si hay problemas de acceso, asegúrate de que el usuario docker tenga permisos:
   ```bash
   sudo chmod 666 /dev/ttyXXX  # donde XXX es la ruta correcta
   ```

## Mantenimiento

Para mantener el sistema actualizado y seguro:

1. Actualizar los contenedores regularmente:
   ```bash
   docker-compose pull
   docker-compose up -d
   ```

2. Revisar los logs periódicamente:
   ```bash
   docker-compose logs -f homeassistant
   docker-compose logs -f zigbee2mqtt
   docker-compose logs -f mqtt
   ```

3. Monitorear el uso de recursos:
   ```bash
   docker stats
   ```

4. Limpiar datos antiguos periódicamente:
   - Usar la función de purga de historial de Home Assistant
   - Eliminar logs antiguos de Mosquitto y Zigbee2MQTT