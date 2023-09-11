import pandas as pd
import os

OUTPUT_DIR = "output"

def combine_csv_to_dataframe(directory):
    """
    Combina todos los archivos CSV en el directorio especificado en un único DataFrame de pandas.

    Columnas del DataFrame:
    - loc_name: Nombre de la ubicación.
    - loc_region: Región de la ubicación.
    - loc_country: País de la ubicación.
    - loc_lat: Latitud de la ubicación.
    - loc_lon: Longitud de la ubicación.
    - loc_tz_id: Identificador de la zona horaria de la ubicación.
    - loc_localtime_epoch: Tiempo local en formato epoch.
    - loc_localtime: Tiempo local en formato legible.
    - astro_sunrise: Hora del amanecer.
    - astro_sunset: Hora del atardecer.
    - astro_moonrise: Hora en que sale la luna.
    - astro_moonset: Hora en que se pone la luna.
    - astro_moon_phase: Fase lunar.
    - astro_moon_illumination: Iluminación de la luna en porcentaje.
    - date: Fecha de la observación.
    - hour_time: Hora específica de la observación.
    - day_maxtemp_c: Temperatura máxima del día en grados Celsius.
    - day_mintemp_c: Temperatura mínima del día en grados Celsius.
    - day_avgtemp_c: Temperatura promedio del día en grados Celsius.
    - day_condition_text: Descripción textual de la condición climática.
    - day_condition_icon: URL del ícono que representa la condición climática.
    - day_condition_code: Código numérico que representa la condición climática.
    - day_uv: Índice UV del día.
    - hour_temp_c: Temperatura en grados Celsius para la hora específica.
    - hour_temp_f: Temperatura en grados Fahrenheit para la hora específica.
    - hour_is_day: Indicador si es de día (1) o de noche (0).
    - hour_wind_mph: Velocidad del viento en millas por hora.
    - hour_wind_kph: Velocidad del viento en kilómetros por hora.
    - hour_wind_degree: Dirección del viento en grados.
    - hour_wind_dir: Dirección del viento en formato textual (Ej: NE para Noreste).
    - hour_pressure_mb: Presión atmosférica en milibares.
    - hour_pressure_in: Presión atmosférica en pulgadas.
    - hour_precip_mm: Precipitación en milímetros.
    - hour_precip_in: Precipitación en pulgadas.
    - hour_humidity: Humedad en porcentaje.
    - hour_cloud: Cobertura de nubes en porcentaje.
    - hour_feelslike_c: Sensación térmica en grados Celsius.
    - hour_feelslike_f: Sensación térmica en grados Fahrenheit.
    - hour_windchill_c: Sensación térmica con el viento en grados Celsius.
    - hour_windchill_f: Sensación térmica con el viento en grados Fahrenheit.
    - hour_heatindex_c: Índice de calor en grados Celsius.
    - hour_heatindex_f: Índice de calor en grados Fahrenheit.
    - hour_dewpoint_c: Punto de rocío en grados Celsius.
    - hour_dewpoint_f: Punto de rocío en grados Fahrenheit.
    - hour_will_it_rain: Indicador si lloverá (1) o no (0).
    - hour_chance_of_rain: Probabilidad de lluvia en porcentaje.
    - hour_will_it_snow: Indicador si nevará (1) o no (0).
    - hour_chance_of_snow: Probabilidad de nieve en porcentaje.
    - hour_vis_km: Visibilidad en kilómetros.
    - hour_vis_miles: Visibilidad en millas.
    - hour_gust_mph: Ráfagas de viento en millas por hora.
    - hour_gust_kph: Ráfagas de viento en kilómetros por hora.

    Parámetros:
    - directory (str): Ruta del directorio que contiene los archivos CSV.

    Retorna:
    - DataFrame: DataFrame de pandas que combina todos los archivos CSV del directorio especificado.
    """
    # Lista todos los archivos en el directorio que terminen en .csv
    csv_files = [f for f in os.listdir(directory) if f.endswith('.csv')]

    # Crea una lista de DataFrames a partir de los archivos CSV
    dfs = [pd.read_csv(os.path.join(directory, csv_file)) for csv_file in csv_files]

    # Concatena todos los DataFrames en uno solo
    combined_df = pd.concat(dfs, ignore_index=True)

    return combined_df


if __name__ == "__main__":
    df = combine_csv_to_dataframe(OUTPUT_DIR)
    print(df.count())  # Muestra las primeras filas del DataFrame combinado
