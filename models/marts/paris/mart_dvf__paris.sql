{{ config(materialized='table') }}

with source as (
  select *
  from {{ ref('stg_dvf__mutations') }}
  where code_departement = '75'
)

select
  mutation_id,
  date_mutation,
  nature_mutation,
  valeur_fonciere,
  case
    when surface_reelle_bati is not null and surface_reelle_bati > 0 and valeur_fonciere is not null
      then round(valeur_fonciere / surface_reelle_bati, 2)
    else null
  end as prix_m2_bati,
  no_voie,
  type_voie,
  voie,
  concat_ws(' ', no_voie, type_voie, voie) as adresse_ligne_1,
  code_postal,
  commune,
  code_departement,
  type_local,
  surface_reelle_bati,
  surface_terrain,
  nombre_pieces_principales,
  nombre_de_lots,
  coalesce(surface_carrez_lot_1, 0)
    + coalesce(surface_carrez_lot_2, 0)
    + coalesce(surface_carrez_lot_3, 0)
    + coalesce(surface_carrez_lot_4, 0)
    + coalesce(surface_carrez_lot_5, 0) as surface_carrez_totale
from source
