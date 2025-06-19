CREATE DATABASE marine_biodiversity;


USE marine_biodiversity;


CREATE TABLE marine_biodiversity.fish_species (
fish_id INT NOT NULL,
scientific_name VARCHAR(255) NULL,
common_name VARCHAR(255) NULL,
image TEXT NULL,
PRIMARY KEY (fish_id)
);

CREATE TABLE marine_biodiversity.fish_country (
fish_id INT NOT NULL,
country VARCHAR(100) NOT NULL,
FOREIGN KEY (fish_id) REFERENCES fish_species(fish_id)
);

CREATE TABLE marine_biodiversity.thailand (
fish_id INT NOT NULL,
date DATE NOT NULL,
scientific_name VARCHAR(255),
common_name VARCHAR(255),
latitude FLOAT,
longitude FLOAT,
country VARCHAR(100) NOT NULL,
image TEXT,
FOREIGN KEY (fish_id) REFERENCES fish_species(fish_id)
);

CREATE TABLE marine_biodiversity.indonesia (
fish_id INT NOT NULL,
date DATE NOT NULL,
scientific_name VARCHAR(255),
common_name VARCHAR(255),
latitude FLOAT,
longitude FLOAT,
country VARCHAR(100) NOT NULL,
image TEXT,
FOREIGN KEY (fish_id) REFERENCES fish_species(fish_id)
);

CREATE TABLE marine_biodiversity.philippines (
fish_id INT NOT NULL,
date DATE NOT NULL,
scientific_name VARCHAR(255),
common_name VARCHAR(255),
latitude FLOAT,
longitude FLOAT,
country VARCHAR(100) NOT NULL,
image TEXT,
FOREIGN KEY (fish_id) REFERENCES fish_species(fish_id)
);