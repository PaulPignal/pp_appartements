# Appartements dbt Project

Starter `dbt` project configured for a local `duckdb` workflow by default.

## Quick start

1. Create a virtual environment.
2. Install dependencies from `requirements.txt`.
3. Copy `profiles.example.yml` to `~/.dbt/profiles.yml`.
4. Download the official DVF files with `./scripts/download_dvf.sh`.
5. Run `dbt debug`, then `dbt run`.

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

## Project layout

- `models/`: transformation models
- `seeds/`: CSV reference data
- `macros/`: custom Jinja macros
- `tests/`: custom tests
- `scripts/`: helper scripts for data ingestion
