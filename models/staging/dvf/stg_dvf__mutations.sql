{{ config(materialized='table') }}

with source as (
  select *
  from {{ ref('stg_dvf__raw') }}
)

select
  filename as source_filename,
  "Identifiant de document" as identifiant_document,
  "Reference document" as reference_document,
  "1 Articles CGI" as article_cgi_1,
  "2 Articles CGI" as article_cgi_2,
  "3 Articles CGI" as article_cgi_3,
  "4 Articles CGI" as article_cgi_4,
  "5 Articles CGI" as article_cgi_5,
  "No disposition" as no_disposition,
  concat_ws('-', coalesce(filename, ''), coalesce("No disposition", ''), coalesce("Date mutation", '')) as mutation_id,
  try_strptime("Date mutation", '%d/%m/%Y')::date as date_mutation,
  "Nature mutation" as nature_mutation,
  try_cast(replace(nullif("Valeur fonciere", ''), ',', '.') as decimal(18, 2)) as valeur_fonciere,
  "No voie" as no_voie,
  "B/T/Q" as btq,
  "Type de voie" as type_voie,
  "Code voie" as code_voie,
  "Voie" as voie,
  try_cast(nullif("Code postal", '') as integer) as code_postal,
  "Commune" as commune,
  "Code departement" as code_departement,
  "Code commune" as code_commune,
  "Prefixe de section" as prefixe_section,
  "Section" as section,
  "No plan" as no_plan,
  "No Volume" as no_volume,
  "1er lot" as lot_1,
  try_cast(replace(nullif("Surface Carrez du 1er lot", ''), ',', '.') as double) as surface_carrez_lot_1,
  "2eme lot" as lot_2,
  try_cast(replace(nullif("Surface Carrez du 2eme lot", ''), ',', '.') as double) as surface_carrez_lot_2,
  "3eme lot" as lot_3,
  try_cast(replace(nullif("Surface Carrez du 3eme lot", ''), ',', '.') as double) as surface_carrez_lot_3,
  "4eme lot" as lot_4,
  try_cast(replace(nullif("Surface Carrez du 4eme lot", ''), ',', '.') as double) as surface_carrez_lot_4,
  "5eme lot" as lot_5,
  try_cast(replace(nullif("Surface Carrez du 5eme lot", ''), ',', '.') as double) as surface_carrez_lot_5,
  try_cast(nullif("Nombre de lots", '') as integer) as nombre_de_lots,
  "Code type local" as code_type_local,
  "Type local" as type_local,
  "Identifiant local" as identifiant_local,
  try_cast(replace(nullif("Surface reelle bati", ''), ',', '.') as double) as surface_reelle_bati,
  try_cast(nullif("Nombre pieces principales", '') as integer) as nombre_pieces_principales,
  "Nature culture" as nature_culture,
  "Nature culture speciale" as nature_culture_speciale,
  try_cast(replace(nullif("Surface terrain", ''), ',', '.') as double) as surface_terrain
from source
