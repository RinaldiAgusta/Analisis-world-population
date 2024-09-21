--data cleaning

-- 1. Cek baris dengan nilai NULL di kolom penting
SELECT * 
FROM world_populations
WHERE "2022 Population" IS NULL 
   OR "Country/Territory" IS NULL 
   OR "Continent" IS NULL;

-- 2. Hapus baris yang memiliki nilai NULL pada kolom populasi
DELETE FROM world_populations
WHERE "2022 Population" IS NULL;

-- 3. Ubah semua nama negara dan kota menjadi huruf kapital
UPDATE world_populations
SET "Country/Territory" = UPPER("Country/Territory"),
    "Capital" = UPPER("Capital");

-- 4. Cek data duplikat berdasarkan Country/Territory dan Capital
SELECT "Country/Territory", COUNT(*)
FROM world_populations
GROUP BY "Country/Territory"
HAVING COUNT(*) > 1;

-- 5. Hapus baris duplikat
WITH CTE AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY "Country/Territory" ORDER BY "Rank") AS rn
  FROM world_populations
)
DELETE FROM CTE WHERE rn > 1;

-- 6. Cek inkonsistensi data populasi (populasi lebih kecil di tahun mendatang)
SELECT * 
FROM world_populations
WHERE "2022 Population" < "2020 Population"
   OR "2020 Population" < "2015 Population"
   OR "2015 Population" < "2010 Population";

-- Exploratory Data Analisis

--Total populasi dunia tahun 2022:

SELECT SUM("2022 Population") AS total_world_population_2022
FROM world_populations;

--Populasi terbesar di tahun 2022:

SELECT "Country/Territory", "2022 Population"
FROM world_populations
ORDER BY "2022 Population" DESC
LIMIT 10;

--Pertumbuhan populasi terbesar antara tahun 2000 dan 2022:

SELECT "Country/Territory", "2022 Population" - "2000 Population" AS population_growth
FROM world_populations
ORDER BY population_growth DESC
LIMIT 10;

--Kepadatan penduduk tertinggi di tahun 2022:

SELECT "Country/Territory", "Density (per km²)"
FROM world_populations
ORDER BY "Density (per km²)" DESC
LIMIT 10;

--Rata-rata pertumbuhan populasi berdasarkan benua (Continent):

SELECT Continent, AVG("Growth Rate") AS avg_growth_rate
FROM world_populations
GROUP BY Continent;

--Distribusi persentase populasi dunia berdasarkan benua di tahun 2022:

SELECT Continent, SUM("2022 Population") / (SELECT SUM("2022 Population") FROM world_populations) * 100 AS world_population_percentage
FROM world_populations
GROUP BY Continent;

--Negara-negara dengan penurunan populasi antara 2020 dan 2022:

SELECT "Country/Territory", "2022 Population", "2020 Population", ("2022 Population" - "2020 Population") AS population_change
FROM world_populations
WHERE "2022 Population" < "2020 Population";

--Luas wilayah negara terbesar:

SELECT "Country/Territory", "Area (km²)"
FROM world_populations
ORDER BY "Area (km²)" DESC
LIMIT 10;
