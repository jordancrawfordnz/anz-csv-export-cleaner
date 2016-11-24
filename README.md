# ANZ CSV Export Cleaner
I wanted to be able to import my CSV file's into [Goodbudget](https://goodbudget.com/). The CSV files from ANZ have a bunch of extra fields that Goodbudget can't handle. This produces a clean CSV file from these ANZ CSV's to make it easy to identify transactions in Goodbudget.

## Running
Ensure Ruby is installed on your system.

```anz-csv-export-cleaner [path to import CSV]```

An exported CSV will be created under the same name with `.cleaned` before the file extension.
