import sqlite3
import pandas as pd

master_file = input("Enter path to master CSV file: ")
discriminator = input("Enter path to discriminator CSV file: ")
output_file = input("Enter path for output CSV file: ")
compare_column = input("Enter the column name to compare: ")

conn = sqlite3.connect("compare_data.db")

# Load CSVs into SQLite tables automatically
pd.read_csv(master_file).to_sql("master", conn, if_exists="replace", index=False)
pd.read_csv(discriminator).to_sql("discriminator", conn, if_exists="replace", index=False)

# Create an index for performance
conn.execute(f"CREATE INDEX IF NOT EXISTS idx_master_{compare_column} ON master({compare_column});")

# Find rows in discriminator NOT in master
query = f"""
SELECT d.*
FROM discriminator d
LEFT JOIN master m
ON LOWER(TRIM(d.{compare_column})) = LOWER(TRIM(m.{compare_column}))
WHERE m.{compare_column} IS NULL;
"""

missing = pd.read_sql_query(query, conn)
missing.to_csv(output_file, index=False)
print(f"Found {len(missing)} missing records. Saved to {output_file}")