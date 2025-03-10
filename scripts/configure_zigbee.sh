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
    ADAPTER_TYPE="zstack"  # Para adaptadores basados en Texas Instruments
else
    ADAPTER_TYPE="ezsp"  # Valor predeterminado
fi

# Actualizar configuración de Zigbee2MQTT
CONFIG_FILE="../zigbee2mqtt/config/configuration.yaml"

# Hacer backup del archivo de configuración
cp $CONFIG_FILE ${CONFIG_FILE}.backup

# Actualizar la configuración
sed -i "s|port:.*|port: $ZIGBEE_PATH|g" $CONFIG_FILE
sed -i "s|adapter:.*|adapter: $ADAPTER_TYPE|g" $CONFIG_FILE

echo -e "${GREEN}Configuración de Zigbee2MQTT actualizada:${NC}"
echo -e "  - Puerto: ${GREEN}$ZIGBEE_PATH${NC}"
echo -e "  - Adaptador: ${GREEN}$ADAPTER_TYPE${NC}"
echo -e "${YELLOW}Recuerda reiniciar el contenedor de Zigbee2MQTT:${NC}"
echo -e "  docker-compose restart zigbee2mqtt" 