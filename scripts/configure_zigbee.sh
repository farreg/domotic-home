#!/bin/bash

# Script para detectar y configurar automáticamente el adaptador Zigbee
# para Zigbee2MQTT

# Colores para mejor legibilidad
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Configuración automática de adaptador Zigbee ===${NC}"

# Detectar adaptadores USB
echo -e "${YELLOW}Buscando adaptadores Zigbee conectados...${NC}"

# Buscar adaptadores Sonoff
SONOFF_PATH=$(find /dev -name "ttyUSB*" | grep -i "ttyUSB" | head -n 1)

# Si no se encuentra, buscar otros adaptadores comunes
if [ -z "$SONOFF_PATH" ]; then
    # Buscar adaptadores ACM (como Sonoff Dongle Plus)
    ZIGBEE_PATH=$(find /dev -name "tty*" | grep -E "ttyACM|ttyAMA|ttyS" | head -n 1)
else
    ZIGBEE_PATH=$SONOFF_PATH
fi

# Verificar si se encontró algún adaptador
if [ -z "$ZIGBEE_PATH" ]; then
    echo -e "${RED}No se encontraron adaptadores Zigbee. Verifica la conexión USB.${NC}"
    echo -e "${YELLOW}Configurando Zigbee2MQTT con el valor predeterminado /dev/ttyUSB0${NC}"
    ZIGBEE_PATH="/dev/ttyUSB0"
else
    echo -e "${GREEN}Adaptador Zigbee encontrado en: $ZIGBEE_PATH${NC}"
fi

# Determinar el adaptador
if [[ $ZIGBEE_PATH == *"USB"* ]]; then
    ADAPTER_TYPE="ezsp"  # Para adaptadores basados en Silicon Labs (Sonoff, etc.)
elif [[ $ZIGBEE_PATH == *"ACM"* ]]; then
    ADAPTER_TYPE="ezsp"  # Para Sonoff Dongle Plus también usa ezsp
else
    ADAPTER_TYPE="ezsp"  # Valor predeterminado
fi

# Actualizar configuración de Zigbee2MQTT
CONFIG_FILE="../zigbee2mqtt/config/configuration.yaml"

# Hacer backup del archivo de configuración
cp $CONFIG_FILE ${CONFIG_FILE}.backup

# Actualizar la configuración
sed -i "s|port:.*|port: \"${ZIGBEE_PATH}\"|g" $CONFIG_FILE
sed -i "s|adapter:.*|adapter: $ADAPTER_TYPE|g" $CONFIG_FILE

# Actualizar la variable de entorno en el archivo .env
ENV_FILE="../.env"
if [ -f "$ENV_FILE" ]; then
    # Si la variable ya existe, actualizar su valor
    if grep -q "ZIGBEE_ADAPTER_TTY=" "$ENV_FILE"; then
        sed -i "s|ZIGBEE_ADAPTER_TTY=.*|ZIGBEE_ADAPTER_TTY=$ZIGBEE_PATH|g" "$ENV_FILE"
        echo -e "${GREEN}Variable ZIGBEE_ADAPTER_TTY actualizada en .env${NC}"
    else
        # Si la variable no existe, añadirla al final del archivo
        echo "" >> "$ENV_FILE"
        echo "# Ruta del dispositivo Zigbee detectado automáticamente" >> "$ENV_FILE"
        echo "ZIGBEE_ADAPTER_TTY=$ZIGBEE_PATH" >> "$ENV_FILE"
        echo -e "${GREEN}Variable ZIGBEE_ADAPTER_TTY añadida a .env${NC}"
    fi
else
    echo -e "${RED}Archivo .env no encontrado. Por favor, crea el archivo .env basado en .env.example${NC}"
fi

echo -e "${GREEN}Configuración de Zigbee2MQTT actualizada:${NC}"
echo -e "  - Puerto: ${GREEN}$ZIGBEE_PATH${NC}"
echo -e "  - Adaptador: ${GREEN}$ADAPTER_TYPE${NC}"
echo -e "${YELLOW}Para aplicar los cambios, ejecuta:${NC}"
echo -e "  cd .."
echo -e "  docker-compose down"
echo -e "  docker-compose up -d" 