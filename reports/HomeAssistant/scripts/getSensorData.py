import requests
import os
import pandas as pd
from datetime import datetime

# Configuración
HOME_ASSISTANT_URL = "http://192.168.68.64:8123"
TOKEN = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIzNGFjOWJmMDE4ZDc0OTJlYWZhY2JiYzI1YTk4YjMyOSIsImlhdCI6MTY5MjU2NDU1MiwiZXhwIjoyMDA3OTI0NTUyfQ.xPhlVOb3Az1rPyV-H1s-IsxGMMdIAUTzvG2vd87QyZE'
HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json",
}

def get_sensor_history(entity_id, start_date, end_date):
    """Obtiene los datos históricos de un sensor en Home Assistant."""
    url = f"{HOME_ASSISTANT_URL}/api/history/period/{start_date}?end_time={end_date}&filter_entity_id={entity_id}"
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error al obtener datos históricos de {entity_id}. Código de estado: {response.status_code}")
        return None

if __name__ == "__main__":
    # Lista de nombres de sensores
    sensor_names = ["temperatura_habitacion", "temperatura_cocina"]

    start_date = "2023-06-01"
    end_date = datetime.now().strftime('%Y-%m-%d')

    all_data = []

    for sensor_name in sensor_names:
        # Construir entity_id para temperatura y humedad
        temp_entity_id = f"sensor.{sensor_name}_temperature"
        humidity_entity_id = f"sensor.{sensor_name}_humidity"

        # Obtener datos históricos
        temp_history = get_sensor_history(temp_entity_id, start_date, end_date)
        humidity_history = get_sensor_history(humidity_entity_id, start_date, end_date)

        # Procesar datos de temperatura
        for record in temp_history[0]:
            all_data.append({
                'sensor_name': sensor_name + "_temperature",
                'timestamp': record['last_changed'],
                'value': record['state']
            })

        # Procesar datos de humedad
        for record in humidity_history[0]:
            all_data.append({
                'sensor_name': sensor_name + "_humidity",
                'timestamp': record['last_changed'],
                'value': record['state']
            })

    # Crear DataFrame
    df = pd.DataFrame(all_data)
    
    output_path = 'output/HomeAssistant'
    
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    # Exportar a CSV
    df.to_csv(f'{output_path}/sensor_data.csv', index=False)



    print(df)
