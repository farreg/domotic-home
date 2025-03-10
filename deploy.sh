#!/bin/bash

# Variables de configuración - Editar estas variables
RASPBERRY_IP="IP_DE_TU_RASPBERRY"
SSH_USER="pi"
SSH_KEY="~/.ssh/id_rsa"  # Ruta a tu clave SSH o "" para usar contraseña
REPO_DIR="/home/pi/domotic-home"

# Colores para mejor legibilidad
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Iniciando despliegue a Raspberry Pi ===${NC}"

# Verificar conexión SSH
echo -e "${YELLOW}Verificando conexión SSH a Raspberry Pi...${NC}"
if ssh -i $SSH_KEY $SSH_USER@$RASPBERRY_IP "echo Conexión exitosa"; then
    echo -e "${GREEN}Conexión SSH establecida correctamente${NC}"
else
    echo -e "${RED}Error: No se pudo establecer conexión SSH${NC}"
    exit 1
fi

# Crear directorios necesarios en la Raspberry Pi
echo -e "${YELLOW}Creando directorios necesarios...${NC}"
ssh -i $SSH_KEY $SSH_USER@$RASPBERRY_IP "mkdir -p $REPO_DIR/volumes/homeassistant $REPO_DIR/volumes/mosquitto/{config,log,data} $REPO_DIR/volumes/esphome $REPO_DIR/zigbee2mqtt/data"

# Transferir archivos
echo -e "${YELLOW}Transfiriendo archivos...${NC}"
rsync -avz --exclude 'node_modules' --exclude '.git' -e "ssh -i $SSH_KEY" ./ $SSH_USER@$RASPBERRY_IP:$REPO_DIR/

# Transferir el archivo .env (debe existir localmente)
if [ -f .env ]; then
    echo -e "${YELLOW}Transfiriendo archivo .env con secrets...${NC}"
    scp -i $SSH_KEY .env $SSH_USER@$RASPBERRY_IP:$REPO_DIR/
else
    echo -e "${RED}Advertencia: No se encontró archivo .env local. Asegúrate de crear uno en la Raspberry Pi.${NC}"
fi

# Verificar Docker y Docker Compose en la Raspberry Pi
echo -e "${YELLOW}Verificando instalación de Docker y Docker Compose...${NC}"
ssh -i $SSH_KEY $SSH_USER@$RASPBERRY_IP "
    if ! command -v docker &> /dev/null; then
        echo 'Docker no está instalado. Instalando...'
        curl -sSL https://get.docker.com | sh
        sudo usermod -aG docker $USER
    else
        echo 'Docker ya está instalado'
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo 'Docker Compose no está instalado. Instalando...'
        sudo apt-get update
        sudo apt-get install -y python3-pip
        sudo pip3 install docker-compose
    else
        echo 'Docker Compose ya está instalado'
    fi
"

# Iniciar los contenedores
echo -e "${YELLOW}Iniciando contenedores...${NC}"
ssh -i $SSH_KEY $SSH_USER@$RASPBERRY_IP "cd $REPO_DIR && docker-compose pull && docker-compose up -d"

# Verificar que los contenedores están corriendo
echo -e "${YELLOW}Verificando estado de los contenedores...${NC}"
ssh -i $SSH_KEY $SSH_USER@$RASPBERRY_IP "cd $REPO_DIR && docker-compose ps"

echo -e "${GREEN}=== Despliegue completado con éxito ===${NC}"
echo -e "${GREEN}Accede a Home Assistant en http://$RASPBERRY_IP:8123${NC}"
echo -e "${GREEN}Accede a Zigbee2MQTT en http://$RASPBERRY_IP:8080${NC}"
echo -e "${GREEN}Accede a ESPHome en http://$RASPBERRY_IP:6052${NC}" 