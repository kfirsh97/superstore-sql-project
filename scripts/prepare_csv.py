"""Convert the raw Superstore Excel file into a clean CSV ready for SQL Server BULK INSERT.

Usage:
    pip install pandas xlrd
    python scripts/prepare_csv.py "sample_-_superstore.xls" data/superstore.csv
"""
import sys
import unicodedata

import pandas as pd

src, dst = sys.argv[1], sys.argv[2]

# 1. Read the raw Excel file
df = pd.read_excel(src)

# 2. Clean column names (no spaces, dashes or slashes)
df.columns = [c.replace("/", "_").replace("-", "_").replace(" ", "_") for c in df.columns]

# 3. Normalize dates to ISO format (YYYY-MM-DD)
for c in ["Order_Date", "Ship_Date"]:
    df[c] = pd.to_datetime(df[c]).dt.strftime("%Y-%m-%d")

# 4. Postal codes as text (US numeric + Canadian alphanumeric codes)
df["Postal_Code"] = (
    df["Postal_Code"].astype(str).str.replace(r"\.0$", "", regex=True).replace("nan", "")
)

# 5. Replace special characters (smart quotes, accents) with plain ASCII
fix = str.maketrans({"”": '"', "“": '"', "’": "'", "‘": "'", "–": "-", "—": "-"})


def to_plain(s: str) -> str:
    s = s.translate(fix)
    return unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode()


for c in df.select_dtypes(exclude="number").columns:
    df[c] = df[c].astype(str).map(to_plain)

# 6. Round floating-point noise and save
for c in ["Sales", "Discount", "Profit"]:
    df[c] = df[c].round(4)

df.to_csv(dst, index=False, encoding="ascii", lineterminator="\n")

# Sanity checks
check = pd.read_csv(dst)
print(f"rows={len(check)} cols={check.shape[1]} total_profit={check['Profit'].sum():.4f}")
