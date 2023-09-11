import requests

# Configuración
HOME_ASSISTANT_URL = "http://192.168.68.64:8123"
TOKEN = ''
HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json",
}

def get_all_entities():
    """Obtiene una lista de todas las entidades en Home Assistant."""
    url = f"{HOME_ASSISTANT_URL}/api/states"
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error al obtener entidades. Código de estado: {response.status_code}")
        return None

if __name__ == "__main__":
    entities = get_all_entities()
    if entities:
        for entity in entities:
            print(entity['entity_id'])

