{% macro normalize_text(expression) -%}
lower(
  regexp_replace(
    translate(
      coalesce({{ expression }}, ''),
      'ABCDEFGHIJKLMNOPQRSTUVWXYZÀÂÄÆÇÉÈÊËÎÏÔŒÙÛÜŸÁÍÓÚÑ',
      'abcdefghijklmnopqrstuvwxyzaaaaaceeeeiiouuuyaioun'
    ),
    '[^a-z0-9]',
    '',
    'g'
  )
)
{%- endmacro %}
