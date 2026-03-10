select
  id,
  id as duplicated_id
from {{ ref('my_first_dbt_model') }}
