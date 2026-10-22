# Superstore SQL Project

End-to-end analytics project on the Superstore sales dataset (10,194 order lines), built on **Microsoft SQL Server 2022** running in Docker on macOS.

## Key finding

About 19% of order lines (1,901) are loss-making, costing ~$157K against a total profit of ~$292K.
**Every loss-making line was sold at a discount**, and profitability flips sharply above a 20% discount:

| Discount band | Rows | % loss-making | Total profit |
|---|---|---|---|
| 0% | 4,925 | 0% | +$326,719 |
| 0–10% | 96 | 4% | +$9,100 |
| 10–20% | 3,758 | 14% | +$92,499 |
| 20–30% | 230 | 92% | −$10,513 |
| 30–50% | 311 | 92% | −$48,477 |
| 50–80% | 874 | 100% | −$77,030 |

Biggest losers by sub-category: Binders (−$38.6K), Tables (−$32.5K), Machines (−$30.1K).

**Recommendation:** cap discounts at 20%, especially for Binders, Tables and Machines.

## Repository structure

```
data/superstore.csv            clean CSV, ready for BULK INSERT
scripts/prepare_csv.py         Excel -> clean CSV (pandas)
sql/01_load_superstore.sql     creates the Practice DB and loads the table
sql/02_discount_analysis.sql   the negative-profit investigation
```

## How to run

1. Start SQL Server in Docker:
   ```bash
   docker run --platform linux/amd64 -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=<your_password>' \
     -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest
   ```
2. Copy the CSV into the container:
   ```bash
   docker cp data/superstore.csv sqlserver:/tmp/superstore.csv
   docker exec -u root sqlserver chmod 644 /tmp/superstore.csv   # let SQL Server read the file
   ```
3. Run `sql/01_load_superstore.sql`, then `sql/02_discount_analysis.sql` (VS Code + MSSQL extension).

## Data preparation

`scripts/prepare_csv.py` cleans the raw Excel file: normalizes column names, converts dates to ISO format,
keeps postal codes as text (the data includes Canadian alphanumeric codes), replaces non-ASCII characters,
and rounds floating-point noise. It validates the output by re-reading it and checking row count and total profit.

## Roadmap

- [x] Load raw data into SQL Server
- [x] Discount / negative-profit analysis
- [ ] Staging layer + star schema (fact & dimension tables)
- [ ] Advanced analysis (window functions, cohorts, MoM growth)
- [ ] Azure SQL Database + Azure Data Factory pipeline
- [ ] Power BI / Tableau dashboard
