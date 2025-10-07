# This is a script that will take in two CSV files and compare the values in a specified column.
# It will then output the differences to a new CSV file.
param (
    [string]$File1,
    [string]$ColumnName1,
    [string]$File2,
    [string]$ColumnName2,
    [string]$OutputFile = "Differences.csv"
)

# Import the CSV files
$csv1 = Import-Csv -Path $File1
$csv2 = Import-Csv -Path $File2

# Extract the specified columns
$column1 = $csv1 | Select-Object -ExpandProperty $ColumnName1
$column2 = $csv2 | Select-Object -ExpandProperty $ColumnName2

# Find differences
$differences = Compare-Object -ReferenceObject $column1 -DifferenceObject $column2

# Output the differences to a new CSV file
$differences | Export-Csv -Path $OutputFile -NoTypeInformation
Write-Host "Differences have been exported to $OutputFile"

# Example usage:
# .\CompareCSVColumn.ps1 -File1 "C:\Path\To\File1.csv" -ColumnName1 "ColumnA" -File2 "C:\Path\To\File2.csv" -ColumnName2 "ColumnB" -OutputFile "C:\Path\To\Differences.csv"
# Note: Ensure that the column names provided exist in the respective CSV files.