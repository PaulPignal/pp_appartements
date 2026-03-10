{{ config(materialized='table') }}

select
  mutation_id,
  date_mutation as date_vente,
  nature_mutation as type_mutation,
  valeur_fonciere as prix_vente,
  prix_m2_bati as prix_m2,
  distance_meters as distance_metres,
  no_voie as numero_voie,
  type_voie,
  voie as nom_voie,
  adresse_ligne_1 as adresse,
  code_postal,
  commune,
  right(cast(code_postal as varchar), 2) as arrondissement,
  type_local as type_bien,
  surface_reelle_bati as surface_batie_m2,
  surface_carrez_totale as surface_carrez_m2,
  surface_terrain as surface_terrain_m2,
  nombre_pieces_principales as nombre_pieces,
  nombre_de_lots as nombre_lots,
  longitude,
  latitude
from {{ ref('mart_dvf__paris_within_radius') }}
where type_local = 'Appartement'
