import streamlit as st
st.set_page_config(layout="wide")

import pandas as pd
import folium
from folium.plugins import MarkerCluster
from streamlit_folium import st_folium

# ========================
# CSS: imagen de fondo total + texto blanco
# ========================
st.markdown(
    """
    <style>
    /* Fondo con imagen */
    .stApp {
        background: url("https://i.imgur.com/WwgN31Y.jpg") no-repeat center center fixed;
        background-size: cover;
        color: white;
    }

    /* Sidebar translúcida */
    .stSidebar {
        background-color: rgba(0, 0, 0, 0.5) !important;
        color: white !important;
    }

    /* Textos blancos */
    .block-container, .main, .css-18e3th9, .css-1cpxqw2, .css-hxt7ib {
        background-color: rgba(0, 0, 0, 0) !important;
        color: white !important;
    }

    .css-1d391kg, .css-1v0mbdj, .css-1cypcdb, .css-10trblm,
    .stSidebar label, .stSidebar section, .stSidebar span, .stSidebar h3, .stSidebar p {
        color: white !important;
    }

    /* Título principal más arriba */
    h1 {
        margin-top: -4rem;
        padding-top: 0rem;
    }

    /* Subtítulo más arriba también */
    p {
        margin-top: -2rem;
    }

    /* Ocultar header/footer Streamlit */
    header, footer {
        visibility: hidden;
    }
    </style>
    """,
    unsafe_allow_html=True
)

# ========================
# Cargar datos
# ========================
df = pd.read_csv("marine_biodiversity_filtered.csv")

# ========================
# Título
# ========================
st.title("Marine Biodiversity Observations in Southeast Asia")
st.markdown("Filter by year, month, country, or species. Click on any point to view image.")

# ========================
# Filtros
# ========================
st.sidebar.header("Filter")

# Año
min_year, max_year = int(df["Year"].min()), int(df["Year"].max())
selected_year_range = st.sidebar.slider("Year Range:", min_value=min_year, max_value=max_year, value=(min_year, max_year))

# Meses con nombres
month_labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
month_mapping = dict(zip(month_labels, range(1, 13)))

month_start, month_end = st.sidebar.select_slider(
    "Month Range:",
    options=month_labels,
    value=("Jan", "Dec")
)
month_range = (month_mapping[month_start], month_mapping[month_end])

# Países
countries = sorted(df['country'].dropna().unique())
selected_countries = st.sidebar.multiselect("Country:", options=countries, default=countries)

# Especies
species_input = st.sidebar.text_input("Search species (comma-separated):")
species_list = [s.strip().lower() for s in species_input.split(",") if s.strip()]

# ========================
# Filtrado
# ========================
filtered_df = df[
    (df["Year"] >= selected_year_range[0]) &
    (df["Year"] <= selected_year_range[1]) &
    (df["Month"] >= month_range[0]) &
    (df["Month"] <= month_range[1]) &
    (df["country"].isin(selected_countries))
]

if species_list:
    filtered_df = filtered_df[filtered_df["common_name"].str.lower().apply(lambda name: any(spec in name for spec in species_list))]

# ========================
# Límite
# ========================
MAX_POINTS = 500
if len(filtered_df) > MAX_POINTS:
    filtered_df = filtered_df.sample(MAX_POINTS, random_state=42)

# ========================
# 🗺️ Mapa
# ========================
if filtered_df.empty:
    st.warning("No observations found with the selected filters.")
    m = folium.Map(location=[7, 120], zoom_start=4, tiles="CartoDB positron")
else:
    m = folium.Map(
        location=[filtered_df['latitude'].mean(), filtered_df['longitude'].mean()],
        zoom_start=5,
        tiles="CartoDB positron"
    )
    marker_cluster = MarkerCluster().add_to(m)

    for _, row in filtered_df.iterrows():
        popup_html = f"""
        <b>{row['common_name']}</b><br>
        Date: {row['date']}<br>
        <img src="{row['image']}" width="200"><br>
        """
        folium.Marker(
            location=[row['latitude'], row['longitude']],
            popup=folium.Popup(popup_html, max_width=250)
        ).add_to(marker_cluster)

# ========================
# Mostrar
# ========================
st_folium(m, width=1000, height=600)