{{ config(materialized='table') }}

with dvf as (
  select *
  from {{ ref('mart_dvf__paris') }}
),

addresses as (
  select *
  from {{ ref('stg_addresses__paris') }}
),

reference_address as (
  select *
  from {{ ref('stg_addresses__reference') }}
),

matched as (
  select
    dvf.*,
    addresses.cle_interop,
    addresses.longitude,
    addresses.latitude
  from dvf
  inner join addresses
    on coalesce(dvf.no_voie, '') = coalesce(addresses.numero, '')
   and coalesce(cast(dvf.code_postal as varchar), '') = coalesce(addresses.code_postal, '')
   and {{ normalize_text("concat_ws(' ', dvf.type_voie, dvf.voie)") }} = addresses.voie_norm
),

scored as (
  select
    matched.*,
    reference_address.longitude as reference_longitude,
    reference_address.latitude as reference_latitude,
    {{ haversine_distance_meters(
      'matched.latitude',
      'matched.longitude',
      'reference_address.latitude',
      'reference_address.longitude'
    ) }} as distance_meters
  from matched
  cross join reference_address
)

select
  mutation_id,
  date_mutation,
  nature_mutation,
  valeur_fonciere,
  prix_m2_bati,
  round(distance_meters, 2) as distance_meters,
  no_voie,
  type_voie,
  voie,
  adresse_ligne_1,
  code_postal,
  commune,
  type_local,
  surface_reelle_bati,
  surface_terrain,
  nombre_pieces_principales,
  nombre_de_lots,
  surface_carrez_totale,
  longitude,
  latitude
from scored
where distance_meters <= {{ var('search_radius_meters', 500) }}
