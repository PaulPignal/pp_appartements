{{ config(materialized='view') }}

with source as (
  select *
  from read_csv(
    '{{ var("paris_addresses_csv", "data/addresses/paris/adresses-paris.csv") }}',
    delim=';',
    header=true,
    all_varchar=true
  )
)

select
  "﻿cle_interop" as cle_interop,
  commune_nom,
  voie_nom,
  numero,
  suffixe,
  commune_insee,
  position,
  try_cast(x as double) as x_l93,
  try_cast(y as double) as y_l93,
  source,
  date_der_maj,
  try_cast(long as double) as longitude,
  try_cast(lat as double) as latitude,
  certification_commune,
  case
    when commune_insee like '751%' then concat('750', right(commune_insee, 2))
    else null
  end as code_postal,
  {{ normalize_text('voie_nom') }} as voie_norm,
  {{ normalize_text('commune_nom') }} as commune_norm
from source
