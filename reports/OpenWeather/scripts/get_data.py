import requests
import csv
import os
from datetime import datetime, timedelta

# Configuración inicial
API_ENDPOINT = "http://api.weatherapi.com/v1/history.json"
API_KEY = "
LOCATION = "-34.6282,-58.5201"
START_DATE = datetime(2023, 6, 17)
END_DATE = datetime(2023, 6, 17)
#END_DATE = datetime.now()
OUTPUT_DIR = "output"

# Asegurarse de que la carpeta de salida exista
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

# Función para obtener el clima de un día específico
def get_weather_for_date(date):
    params = {
        "key": API_KEY,
        "q": LOCATION,
        "dt": date.strftime('%Y-%m-%d')
    }
    response = requests.get(API_ENDPOINT, params=params)
    return response.json(), response.status_code

# Función principal
def main():
    current_date = START_DATE
    while current_date <= END_DATE:
        print(f"Fetching data for {current_date.strftime('%Y-%m-%d')}...")
        data, status_code = get_weather_for_date(current_date)
        print(f"Status code: {status_code}")

        if status_code == 200:
            with open(os.path.join(OUTPUT_DIR, f'weather_data_{current_date.strftime("%Y-%m-%d")}.csv'), 'w', newline='') as csvfile:
                # Definimos los campos del CSV basados en la estructura de la respuesta de la API
                fieldnames = ['loc_name', 'loc_region', 'loc_country', 'loc_lat', 'loc_lon', 'loc_tz_id', 'loc_localtime_epoch', 'loc_localtime', 'astro_sunrise', 'astro_sunset', 'astro_moonrise', 'astro_moonset', 'astro_moon_phase', 'astro_moon_illumination', 'date', 'hour_time', 'day_maxtemp_c', 'day_mintemp_c', 'day_avgtemp_c', 'day_condition_text', 'day_condition_icon', 'day_condition_code', 'day_uv', 'hour_temp_c', 'hour_temp_f', 'hour_is_day', 'hour_wind_mph', 'hour_wind_kph', 'hour_wind_degree', 'hour_wind_dir', 'hour_pressure_mb', 'hour_pressure_in', 'hour_precip_mm', 'hour_precip_in', 'hour_humidity', 'hour_cloud', 'hour_feelslike_c', 'hour_feelslike_f', 'hour_windchill_c', 'hour_windchill_f', 'hour_heatindex_c', 'hour_heatindex_f', 'hour_dewpoint_c', 'hour_dewpoint_f', 'hour_will_it_rain', 'hour_chance_of_rain', 'hour_will_it_snow', 'hour_chance_of_snow', 'hour_vis_km', 'hour_vis_miles', 'hour_gust_mph', 'hour_gust_kph']
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()

                location_data = data['location']
                daily_data = data['forecast']['forecastday'][0]['day']
                astro_data = data['forecast']['forecastday'][0]['astro']

                for hour_data in data['forecast']['forecastday'][0]['hour']:
                    writer.writerow({
                        'loc_name': location_data.get('name', ''),
                        'loc_region': location_data.get('region', ''),
                        'loc_country': location_data.get('country', ''),
                        'loc_lat': location_data.get('lat', ''),
                        'loc_lon': location_data.get('lon', ''),
                        'loc_tz_id': location_data.get('tz_id', ''),
                        'loc_localtime_epoch': location_data.get('localtime_epoch', ''),
                        'loc_localtime': location_data.get('localtime', ''),
                        'astro_sunrise': astro_data.get('sunrise', ''),
                        'astro_sunset': astro_data.get('sunset', ''),
                        'astro_moonrise': astro_data.get('moonrise', ''),
                        'astro_moonset': astro_data.get('moonset', ''),
                        'astro_moon_phase': astro_data.get('moon_phase', ''),
                        'astro_moon_illumination': astro_data.get('moon_illumination', ''),
                        'date': current_date.strftime('%Y-%m-%d'),
                        'hour_time': hour_data.get('time', ''),
                        'day_maxtemp_c': daily_data.get('maxtemp_c', ''),
                        'day_mintemp_c': daily_data.get('mintemp_c', ''),
                        'day_avgtemp_c': daily_data.get('avgtemp_c', ''),
                        'day_condition_text': daily_data.get('condition', {}).get('text', ''),
                        'day_condition_icon': daily_data.get('condition', {}).get('icon', ''),
                        'day_condition_code': daily_data.get('condition', {}).get('code', ''),
                        'day_uv': daily_data.get('uv', ''),
                        'hour_temp_c': hour_data.get('temp_c', ''),
                        'hour_temp_f': hour_data.get('temp_f', ''),
                        'hour_is_day': hour_data.get('is_day', ''),
                        'hour_wind_mph': hour_data.get('wind_mph', ''),
                        'hour_wind_kph': hour_data.get('wind_kph', ''),
                        'hour_wind_degree': hour_data.get('wind_degree', ''),
                        'hour_wind_dir': hour_data.get('wind_dir', ''),
                        'hour_pressure_mb': hour_data.get('pressure_mb', ''),
                        'hour_pressure_in': hour_data.get('pressure_in', ''),
                        'hour_precip_mm': hour_data.get('precip_mm', ''),
                        'hour_precip_in': hour_data.get('precip_in', ''),
                        'hour_humidity': hour_data.get('humidity', ''),
                        'hour_cloud': hour_data.get('cloud', ''),
                        'hour_feelslike_c': hour_data.get('feelslike_c', ''),
                        'hour_feelslike_f': hour_data.get('feelslike_f', ''),
                        'hour_windchill_c': hour_data.get('windchill_c', ''),
                        'hour_windchill_f': hour_data.get('windchill_f', ''),
                        'hour_heatindex_c': hour_data.get('heatindex_c', ''),
                        'hour_heatindex_f': hour_data.get('heatindex_f', ''),
                        'hour_dewpoint_c': hour_data.get('dewpoint_c', ''),
                        'hour_dewpoint_f': hour_data.get('dewpoint_f', ''),
                        'hour_will_it_rain': hour_data.get('will_it_rain', ''),
                        'hour_chance_of_rain': hour_data.get('chance_of_rain', ''),
                        'hour_will_it_snow': hour_data.get('will_it_snow', ''),
                        'hour_chance_of_snow': hour_data.get('chance_of_snow', ''),
                        'hour_vis_km': hour_data.get('vis_km', ''),
                        'hour_vis_miles': hour_data.get('vis_miles', ''),
                        'hour_gust_mph': hour_data.get('gust_mph', ''),
                        'hour_gust_kph': hour_data.get('gust_kph', '')
                    })
        else:
            print(f"Failed to fetch data for {current_date.strftime('%Y-%m-%d')}.")

        current_date += timedelta(days=1)

if __name__ == "__main__":
    main()
