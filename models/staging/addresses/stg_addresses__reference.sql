{{ config(materialized='view') }}

select
  *
from {{ ref('stg_addresses__paris') }}
where numero = '{{ var("reference_no_voie", "204") }}'
  and code_postal = '{{ var("reference_code_postal", "75015") }}'
  and {{ normalize_text('voie_nom') }} = {{ normalize_text("'" ~ var("reference_voie", "Rue de Vaugirard") ~ "'") }}
  and {{ normalize_text('commune_nom') }} = {{ normalize_text("'" ~ var("reference_commune", "Paris") ~ "'") }}
qualify row_number() over (order by cle_interop) = 1
