{{ config(materialized='table') }}

with source as (
  select *
  from {{ ref('mart_dvf__paris_appartements_within_radius') }}
),

filtered as (
  select *
  from source
  where prix_m2 is not null
    and surface_batie_m2 is not null
    and surface_batie_m2 > 0
)

select
  date_vente,
  round(prix_vente, 0) as prix_vente,
  round(prix_m2, 0) as prix_m2,
  round(distance_metres, 0) as distance_metres,
  adresse,
  code_postal,
  arrondissement,
  round(surface_batie_m2, 1) as surface_batie_m2,
  round(surface_carrez_m2, 1) as surface_carrez_m2,
  nombre_pieces,
  case
    when surface_batie_m2 >= 15 and prix_m2 is not null
      then round(prix_vente / nullif(nombre_pieces, 0), 0)
    else null
  end as prix_par_piece,
  case
    when date_vente >= current_date - interval 365 day then '12 derniers mois'
    when date_vente >= current_date - interval 730 day then '12-24 mois'
    else 'plus de 24 mois'
  end as anciennete_vente
from filtered
order by distance_metres asc, date_vente desc, prix_m2 desc
