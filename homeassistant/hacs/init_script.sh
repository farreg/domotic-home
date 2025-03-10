#!/bin/bash

# Script para instalar HACS en Home Assistant
# https://hacs.xyz/

# Colores para mejor legibilidad
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

HA_CONFIG_PATH=${HA_CONFIG_PATH:-"/config"}
HACS_PATH="$HA_CONFIG_PATH/custom_components/hacs"
LOG_FILE="$HA_CONFIG_PATH/hacs_install.log"

echo "Iniciando script de instalación de HACS..." | tee -a $LOG_FILE

# Verificar si HACS ya está instalado
if [ -d "$HACS_PATH" ]; then
  echo -e "${GREEN}$(date) - HACS ya está instalado. Verificando actualizaciones...${NC}" | tee -a $LOG_FILE
  
  # Verificar si hay actualizaciones disponibles (opcional)
  # Por ahora, simplemente salimos
  exit 0
fi

echo -e "${YELLOW}$(date) - Instalando HACS...${NC}" | tee -a $LOG_FILE

# Crear el directorio si no existe
mkdir -p $HACS_PATH

# Descargar HACS
echo "Descargando HACS..." | tee -a $LOG_FILE
if ! wget -q -O /tmp/hacs.zip https://github.com/hacs/integration/releases/latest/download/hacs.zip; then
  echo -e "${RED}$(date) - Error al descargar HACS${NC}" | tee -a $LOG_FILE
  exit 1
fi

# Descomprimir HACS
echo "Descomprimiendo HACS..." | tee -a $LOG_FILE
if ! unzip -q -o /tmp/hacs.zip -d $HACS_PATH; then
  echo -e "${RED}$(date) - Error al descomprimir HACS${NC}" | tee -a $LOG_FILE
  exit 1
fi

# Limpiar archivos temporales
rm /tmp/hacs.zip

# Configurar permisos adecuados
chmod -R 755 $HACS_PATH

echo -e "${GREEN}$(date) - HACS instalado con éxito.${NC}" | tee -a $LOG_FILE
echo -e "${YELLOW}Recuerda agregar el token de GitHub en tu configuration.yaml:${NC}" | tee -a $LOG_FILE
echo "hacs:" | tee -a $LOG_FILE
echo "  token: \${HA_GITHUB_TOKEN}" | tee -a $LOG_FILE
