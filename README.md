# Oceans of Data  

**Tracking Marine Life in Southeast Asia (2015 – 2025)**  

Pol Urbano Kinsel


## 1. Project Objective

This project analyzes the spatial and temporal distribution of marine species sightings in Thailand, Indonesia, and the Philippines between 2015 and 2025.  
A unified, geolocated database—built from the public iNaturalist API—supports interactive visualizations that:

* Profile biodiversity hotspots  
* Reveal seasonal and long-term trends  
* Inform conservation, responsible dive tourism, and monitoring of vulnerable species


## 2. Project Plan

 1. Problem Definition - Select research question and iNaturalist as data source 
 2. Data Extraction - Automated API calls per year, month and per country (avoids 10 k-record limit) 
 3. Storage & Backup - One CSV per year/month; raw archive kept for reproducibility
 4. Cleaning & Integration - Remove duplicates, fix taxonomic names, merge into SQLite 
 5. SQL Analysis - Normalised schema (Countries, Species, Observations) and analytical views  
 6. Visualization - Dashboards and charts | Power BI |
 7. Interactive map with filters in Streamlit


## 3. Data Sources

* **API**  <https://api.inaturalist.org/v1/observations> 
* **Taxa**  Bony fish (47178) • Sharks & Rays (505362) • Cetaceans (152871) • Sea turtles (query)
* **Geography**  Bounding boxes for Thailand, Indonesia, Philippines 
* **Period**  Jan 2015 – Jun 2025 
* **Fields Collected**  Latitude, Longitude, Date, Scientific & Common names, Photo URL 


## 4. Data Processing Highlights

* Year-/month-level extraction prevents API throttling; network failures are isolated to small files.  
* Full raw archive > 250 k rows → cleaned dataset after removing duplicates and incomplete entries.  
* Normalised schema in SQLite/MySQL accelerates custom SQL queries and Power BI refresh.  
* A **light subset** (whales, sharks, rays, dolphins, turtles) powers the Streamlit map for fast loading.


## 5. SQL Integration

The relational model enables questions such as:

* Most frequently observed species per country  
* Year-over-year change in unique species  
* Species seen in only one country vs. those shared across all three

Analytical views are exported directly into Power BI.


## 6. Exploratory Data Analysis

* 6.1 Country Overview  
Bar and pie charts compare total sightings and unique species by country.

* 6.2 Temporal Trends  
Monthly and yearly plots showing number of observations per country.

* 6.3 Species Focus  
Filtered dashboards top 10 sharks, rays, dolphins, and whales showing where each group dominates.

(See the Power BI report for interactive versions.)


## 7. Streamlit Map

A lightweight web app lets users filter by:

* Year or range of years  
* Month or range of months  
* Country (one, two, or all three)  
* Free-text species search  

Each marker opens a popup with the species name, date, and the original iNaturalist photo.



## 8. Conclusions

* Over 250 k+ observations and 5273 unique species documented.  
* Indonesia registers the highest biodiversity; its 17 500-island archipelago lies inside the Coral Triangle.  
* Sightings fell sharply during the 2020 pandemic lockdowns, then grew exponentially.  
* Several species are highly localised, occurring in a single region.  
* Monsoon seasons influence data volume by limiting dive activity and tourist access.  
* Indonesia and Thailand attract more divers overall, while the Philippines offers exceptional—but less frequented—sites.

---

## 9. Future Improvements

* Extend taxonomic scope to corals, mollusks, nudibranchs.  
* Add neighbouring countries (Malaysia, Cambodia, Vietnam).  
* Enrich with environmental layers: sea-surface temperature, depth, salinity.  
* Harvest records from additional citizen-science platforms to widen coverage.  
* Train a machine-learning model to predict species presence given location + time.  
* Migrate from Streamlit to a more scalable framework (Dash/Flask + React) for complex, multi-page analytics.
