# Appartements dbt Project

Starter `dbt` project configured for a local `duckdb` workflow by default.

## Quick start

1. Create a virtual environment.
2. Install dependencies from `requirements.txt`.
3. Copy `profiles.example.yml` to `~/.dbt/profiles.yml`.
4. Run `dbt debug`, then `dbt run`.

## Project layout

- `models/`: transformation models
- `seeds/`: CSV reference data
- `macros/`: custom Jinja macros
- `tests/`: custom tests

## GitHub

Initialize the remote once you have your GitHub repository URL:

```bash
git remote add origin <github-repo-url>
git branch -M main
git push -u origin main
```
