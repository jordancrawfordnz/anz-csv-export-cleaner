require 'CSV'

class ExportCleaner
  TYPE_FIELD = "Type"
  DETAILS_FIELD = "Details"
  PARTICULARS_FIELD = "Particulars"
  CODE_FIELD = "Code"
  REFERENCE_FIELD = "Reference"
  AMOUNT_FIELD = "Amount"
  DATE_FIELD = "Date"
  DEBIT_VALUE = "DR"
  CREDIT_VALUE = "CR"
  DETAILS_FIELD_SEPERATOR = " - "
  CLEAN_HEADER = [DATE_FIELD, AMOUNT_FIELD, TYPE_FIELD, DETAILS_FIELD]

  def initialize(import_path, export_path)
      @import_path = import_path
      @export_path = export_path

      unless (File.file?(@import_path))
        raise StandardError.new("No input file")
      end
  end

  def check_required_fields(import_row)
    if !import_row[DATE_FIELD]
      raise StandardError.new("A '#{DATE_FIELD}' field is required.")
    elsif !import_row[AMOUNT_FIELD]
      raise StandardError.new("A '#{AMOUNT_FIELD}' field is required.")
    end
  end

  def clean_detail_field(import_row)
    details_fields = []
    if (import_row[CODE_FIELD] && import_row[CODE_FIELD].length > 0)
      details_fields.push(import_row[CODE_FIELD])
    end

    # "Visa Purchase" shouldn't show the Details field.
    # Eft-Pos shouldn't show Particulars
    # Visa Purchase shouldn't have the Reference.
    # Eft-Pos shouldn't have the Reference.

    # Should type be shown?
    # Code and Reference should link Particulars, Code and Reference

    details_field_result = ""
    details_fields.each_with_index do |detail_field, index|
      details_field_result << detail_field
      unless (index == details_fields.length - 1)
        details_field_result << DETAILS_FIELD_SEPERATOR
      end
    end
    details_field_result

    # # TODO: Improve this.
    # clean_row[3] = "#{import_row["Particulars"]} #{import_row["Code"]} #{import_row["Reference"]} - #{import_row["Details"]} #{import_row["Type"]}"
    #
  end

  def build_clean_row(import_row)
    check_required_fields(import_row)

    clean_row = []
    amount = import_row[AMOUNT_FIELD].to_f
    clean_row[0] = import_row[DATE_FIELD]
    clean_row[1] = amount.abs
    clean_row[2] = amount > 0 ? CREDIT_VALUE : DEBIT_VALUE
    clean_row[3] = clean_detail_field(import_row)

    clean_row
  end

  def build_clean_file
    CSV.open(@export_path, "w", :write_headers => true, :headers => CLEAN_HEADER) do |clean_csv|
      CSV.foreach(@import_path, :headers => true) do |import_row|
        clean_csv << build_clean_row(import_row)
      end
    end
  end
end
