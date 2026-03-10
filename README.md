# Appartements dbt Project

Starter `dbt` project configured for a local `duckdb` workflow by default.

## Quick start

1. Create a virtual environment.
2. Install dependencies from `requirements.txt`.
3. Copy `profiles.example.yml` to `~/.dbt/profiles.yml`.
4. Download the official DVF files with `./scripts/download_dvf.sh`.
5. Download the official Paris address file with `./scripts/download_paris_addresses.sh`.
6. Run `dbt debug`, then `dbt run`.

## DVF source

The project uses the official DVF dataset published on data.gouv.fr:
[Demandes de valeurs foncieres](https://www.data.gouv.fr/datasets/demandes-de-valeurs-foncieres).

Important:

- the official resources are `txt.zip`, not CSV files
- the files are pipe-delimited (`|`)
- the dataset is updated twice a year, in April and October
- the latest update published on the dataset page is October 20, 2025

The download script stores archives in `data/dvf/zip/` and extracted files in
`data/dvf/raw/`. Those folders are ignored by Git.

## Radius Search Around An Address

The project can build a table of Paris DVF addresses located within a given
radius of a reference address.

Default variables:

- `reference_no_voie`: `204`
- `reference_voie`: `Rue de Vaugirard`
- `reference_code_postal`: `75015`
- `reference_commune`: `Paris`
- `search_radius_meters`: `500`

Example:

```bash
.venv311/bin/dbt run --select mart_dvf__paris_within_radius
```

## Local Map

To generate a local interactive map from
`main_marts.mart_dvf__paris_appartements_within_radius`:

```bash
.venv311/bin/python scripts/export_map_data.py
cd site/map && python3 -m http.server 8000
```

Then open `http://localhost:8000`.

## GitHub Pages

The repository includes a GitHub Pages workflow that deploys the static map from
`site/map/`.

To activate it in GitHub:

1. Open the repository settings.
2. Go to `Pages`.
3. In `Build and deployment`, select `GitHub Actions` as the source.
4. Push changes to `main`, or manually run the `Deploy Map To GitHub Pages`
   workflow from the `Actions` tab.

Once enabled, the map will be published at a URL like:

`https://paulpignal.github.io/pp_appartements/`

## Project layout

- `models/`: transformation models
- `seeds/`: CSV reference data
- `macros/`: custom Jinja macros
- `tests/`: custom tests
- `scripts/`: helper scripts for data ingestion
