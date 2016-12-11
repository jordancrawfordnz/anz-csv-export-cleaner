# ANZ CSV Export Cleaner
ANZ Bank's CSV export contains many fields, making it difficult to identify transactions. This Gem simplifies these fields, making the file easier to use.

Original fields:
- Type
- Details
- Particulars
- Code
- Reference
- Amount
- Date
- ForeignCurrencyAmount
- ConversionCharge

Cleaned fields:
- Date
- Amount
- Type (DR or CR)
- Details

The Details field is determined using these additional fields, with information that does not help identify transactions being excluded.

## Using as a Gem
Run ``gem install anz_bank_csv_cleaner`` to install the Gem, then use as follows:

```
require anz_bank_csv_cleaner

cleaner = ANZBankCSVCleaner.new(
  import_path: [path to CSV file from ANZ],
  export_path: [desired path for CSV export]
)
cleaner.run
```

## Running on the command line
Ensure Ruby is installed on your system.

```./anz-csv-export-cleaner [path to import CSV]```

An exported CSV will be created under the same name with `.cleaned` before the file extension.
