#!/bin/bash

HA_CONFIG_PATH=${HA_CONFIG_PATH}

HACS_PATH="$HA_CONFIG_PATH/custom_components/hacs"

LOG_FILE="$HA_CONFIG_PATH/hacs_install.log"

if [ -d "$HACS_PATH" ]; then
  echo "$(date) - HACS ya está instalado. Saliendo del script." >> $LOG_FILE
  exit 0
fi

wget -q -O /tmp/hacs.zip https://github.com/hacs/integration/releases/latest/download/hacs.zip

unzip -q -o /tmp/hacs.zip -d $HACS_PATH

rm /tmp/hacs.zip

echo "$(date) - HACS instalado con éxito." >> $LOG_FILE
