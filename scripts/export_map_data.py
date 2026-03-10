#!/usr/bin/env python3

import json
from decimal import Decimal
from pathlib import Path

import duckdb


ROOT = Path(__file__).resolve().parents[1]
DB_PATH = ROOT / "appartements.duckdb"
OUT_DIR = ROOT / "site" / "map"
OUT_FILE = OUT_DIR / "comparables.geojson"
META_FILE = OUT_DIR / "reference.json"


QUERY = """
with source as (
  select
    mutation_id,
    cast(date_vente as varchar) as date_vente,
    prix_vente,
    prix_m2,
    distance_metres,
    adresse,
    code_postal,
    arrondissement,
    surface_batie_m2,
    surface_carrez_m2,
    nombre_pieces,
    longitude,
    latitude
  from main_marts.mart_dvf__paris_appartements_within_radius
  where longitude is not null
    and latitude is not null
    and prix_m2 is not null
    and prix_vente is not null
    and surface_batie_m2 between 10 and 250
    and prix_vente between 50000 and 5000000
),
stats as (
  select
    quantile_cont(prix_m2, 0.05) as p05_prix_m2,
    quantile_cont(prix_m2, 0.95) as p95_prix_m2
  from source
)
select
  source.*
from source
cross join stats
where source.prix_m2 between stats.p05_prix_m2 and stats.p95_prix_m2
order by distance_metres asc, date_vente desc
"""

REFERENCE_QUERY = """
select
  numero as reference_no_voie,
  voie_nom as reference_voie,
  code_postal as reference_code_postal,
  commune_nom as reference_commune,
  longitude,
  latitude
from main_staging.stg_addresses__reference
limit 1
"""


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)

    con = duckdb.connect(str(DB_PATH), read_only=True)
    rows = con.execute(QUERY).fetchall()
    columns = [desc[0] for desc in con.description]
    reference_row = con.execute(REFERENCE_QUERY).fetchone()
    reference_columns = [desc[0] for desc in con.description]

    features = []
    for row in rows:
        record = dict(zip(columns, row))
        lon = record.pop("longitude")
        lat = record.pop("latitude")
        for key, value in list(record.items()):
            if isinstance(value, Decimal):
                record[key] = float(value)
        if isinstance(lon, Decimal):
            lon = float(lon)
        if isinstance(lat, Decimal):
            lat = float(lat)
        features.append(
            {
                "type": "Feature",
                "geometry": {"type": "Point", "coordinates": [lon, lat]},
                "properties": record,
            }
        )

    geojson = {"type": "FeatureCollection", "features": features}
    OUT_FILE.write_text(json.dumps(geojson, ensure_ascii=False), encoding="utf-8")
    if reference_row:
        reference = dict(zip(reference_columns, reference_row))
        for key, value in list(reference.items()):
            if isinstance(value, Decimal):
                reference[key] = float(value)
        META_FILE.write_text(json.dumps(reference, ensure_ascii=False), encoding="utf-8")
    print(f"Wrote {len(features)} features to {OUT_FILE}")


if __name__ == "__main__":
    main()
