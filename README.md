# Domotic Home

Sistema domótico completo basado en Home Assistant, ZHA (Zigbee Home Automation), Mosquitto y ESPHome.

## Características

- **Home Assistant**: Interfaz central para gestionar todos tus dispositivos inteligentes
- **ZHA (Zigbee Home Automation)**: Integración nativa de dispositivos Zigbee en Home Assistant
- **Mosquitto**: Broker MQTT para comunicación entre componentes
- **ESPHome**: Soporte para dispositivos ESP8266/ESP32 personalizados

## Requisitos

- Docker y Docker Compose
- Un adaptador Zigbee compatible (consulta la [lista de adaptadores compatibles](https://www.home-assistant.io/integrations/zha/#known-working-zigbee-radio-modules))
- Sistema Linux/macOS/Windows (Raspberry Pi recomendado)

## Instalación

1. Clona este repositorio:

```bash
git clone https://github.com/farreg/domotic-home.git
cd domotic-home
```

2. Copia el archivo de ejemplo de variables de entorno:

```bash
cp .env.example .env
```

3. Edita el archivo `.env` y configura tus variables:

```bash
# Configura la zona horaria correcta
TZ=America/Argentina/Buenos_Aires

# Configura las credenciales MQTT
MQTT_USERNAME=homeassistant  # Cambia a un nombre de usuario personalizado
MQTT_PASSWORD=mqtt_password  # Cambia a una contraseña segura

# Opcional: Configura un token de GitHub para HACS
# HA_GITHUB_TOKEN=tu_token_de_github
```

4. Configura los secretos (recomendado para mayor seguridad):

```bash
mkdir -p secrets
echo "homeassistant" > secrets/mqtt_username.txt  # Cambia a un nombre de usuario personalizado
echo "mqtt_password" > secrets/mqtt_password.txt  # Cambia a una contraseña segura
# Opcional: Para HACS
# echo "tu_token_de_github" > secrets/ha_github_token.txt
```

5. Inicia los servicios:

```bash
docker-compose up -d
```

6. Accede a las interfaces:

- Home Assistant: `http://tu-ip:8123`
- ESPHome: `http://tu-ip:6052`

7. Configurar ZHA en Home Assistant:

Después de iniciar Home Assistant, ve a "Configuración" -> "Dispositivos y servicios" -> "Añadir integración" y busca "ZHA". Sigue el asistente de configuración y selecciona tu adaptador Zigbee conectado al sistema.

## Autenticación MQTT

El sistema está configurado para utilizar autenticación MQTT, lo que proporciona mayor seguridad en la comunicación entre los componentes:

- Las credenciales se pueden configurar mediante:
  - **Secretos** (recomendado): archivos en `./secrets/mqtt_username.txt` y `./secrets/mqtt_password.txt`
  - **Variables de entorno**: definidas en el archivo `.env`

Si no se proporcionan credenciales, el sistema funcionará en modo anónimo por defecto para facilitar la depuración, pero se recomienda configurar la autenticación para entornos de producción.

## Directorios de Datos

Los datos se almacenan en los siguientes directorios:

- Home Assistant: `./volumes/homeassistant`
- Mosquitto: `./volumes/mosquitto`
- ESPHome: `./volumes/esphome`

Puedes cambiar estas rutas en el archivo `.env`.

## Solución de Problemas

### Problemas con MQTT

Si experimentas problemas con MQTT:

1. Verifica que las credenciales sean correctas en todos los servicios
2. Asegúrate de que el broker Mosquitto esté funcionando: `docker logs mosquitto`
3. Comprueba la conectividad entre servicios: `docker exec -it mosquitto mosquitto_sub -t "#" -v`

### Problemas con Zigbee (ZHA)

Si el adaptador Zigbee no funciona con ZHA:

1. Verifica que el adaptador esté conectado y sea reconocido por el sistema
2. Comprueba que Home Assistant tenga acceso al dispositivo (el contenedor está configurado con montaje de `/dev` y `privileged: true`)
3. Comprueba los permisos del dispositivo: `sudo chmod 666 /dev/ttyACM0` (o el puerto correspondiente)
4. Verifica que el adaptador sea compatible con ZHA

## Respaldo y Restauración

Es recomendable realizar respaldos periódicos de los directorios de datos:

```bash
# Ejemplo de respaldo
tar -czf backup-domotic-home.tar.gz ./volumes
```

## Actualizaciones

Para actualizar los servicios:

```bash
git pull
docker-compose pull
docker-compose up -d
```

## Licencia

Este proyecto está licenciado bajo la Licencia MIT.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, envía pull requests o abre issues para sugerir mejoras.