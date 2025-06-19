import requests
import time
import pandas as pd
from datetime import datetime
from unidecode import unidecode

# Función de limipiar common_name con regex
def clean_common_name(df):
    df['common_name'] = (
        df['common_name']
        .astype(str)
        .str.lower()
        .str.strip()
        .str.replace(r's$', '', regex=True)       # elimina plural simple
        .apply(unidecode)              # elimina acentos
    )
    return df

#Función de arreglar common_name
def fix_fishe(df):
    df['common_name'] = df['common_name'].str.replace('fishe', 'fish', regex=False)
    return df


#  Función con reintento automático hasta 3 veces
def get_with_retry(url, params, headers, max_retries=3, delay=5):
    for attempt in range(1, max_retries + 1):
        try:
            response = requests.get(url, params=params, headers=headers)
            if response.status_code == 200:
                return response
            else:
                print(f"❌ Error {response.status_code} (intento {attempt})")
        except requests.exceptions.RequestException as e:
            print(f"⚠️ Conexión fallida (intento {attempt}): {e}")
        time.sleep(delay)
    return None

#  Función para obtener imagen desde scientific_name o common_name
def get_image_url(scientific_name, common_name=None):
    def search(query):
        url = 'https://api.inaturalist.org/v1/search'
        params = {'q': query, 'sources': 'taxa'}
        response = get_with_retry(url, params=params, headers=headers)
        if response:
            try:
                return response.json()['results'][0]['record']['default_photo']['medium_url']
            except (KeyError, IndexError, TypeError):
                return None
        return None

    # Buscar por scientific_name
    image_url = search(scientific_name)

    # Si falla, intentar con common_name
    if image_url is None and pd.notna(common_name):
        image_url = search(common_name)

    return image_url

#  Función para generar todos los meses válidos
def generate_months(start_year=2022, end_year=2025):
    now = datetime.now()
    months = []
    for year in range(start_year, end_year + 1):
        max_month = 12 if year < now.year else now.month
        for m in range(1, max_month + 1):
            months.append(f"{year}-{str(m).zfill(2)}")
    return months

#  Función para generar todos los meses
def generate_months1(year):
    now = datetime.now()
    last_month = 12 if year < now.year else now.month
    return [f"{year}-{str(m).zfill(2)}" for m in range(1, last_month + 1)]

