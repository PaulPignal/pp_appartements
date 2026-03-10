{{ config(materialized='view') }}

select *
from read_csv(
  '{{ var("dvf_raw_glob", "data/dvf/raw/*.txt") }}',
  delim='|',
  header=true,
  all_varchar=true,
  union_by_name=true,
  filename=true
)
