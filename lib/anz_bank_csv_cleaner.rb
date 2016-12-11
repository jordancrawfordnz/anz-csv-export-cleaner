require 'CSV'

class ANZBankCSVCleaner
  TYPE_FIELD = "Type"
  DETAILS_FIELD = "Details"
  PARTICULARS_FIELD = "Particulars"
  CODE_FIELD = "Code"
  REFERENCE_FIELD = "Reference"
  AMOUNT_FIELD = "Amount"
  DATE_FIELD = "Date"
  DEBIT_VALUE = "DR"
  CREDIT_VALUE = "CR"
  VISA_PURCHASE_TYPE = "Visa Purchase"
  EFTPOS_PURCHASE_TYPE = "Eft-Pos"

  CLEAN_HEADER = [DATE_FIELD, AMOUNT_FIELD, TYPE_FIELD, DETAILS_FIELD]

  def initialize(import_path:, export_path:)
      @import_path = import_path
      @export_path = export_path

      unless (File.file?(@import_path))
        raise StandardError.new("No input file")
      end
  end

  def run
    CSV.open(@export_path, "w", :write_headers => true, :headers => CLEAN_HEADER) do |clean_csv|
      CSV.foreach(@import_path, :headers => true) do |import_row|
        clean_csv << build_clean_row(import_row)
      end
    end
  end

  private

  def check_required_fields(import_row)
    if !import_row[DATE_FIELD]
      raise StandardError.new("A '#{DATE_FIELD}' field is required.")
    elsif !import_row[AMOUNT_FIELD]
      raise StandardError.new("A '#{AMOUNT_FIELD}' field is required.")
    end
  end

  def use_field(field_value)
    field_value && field_value.length > 0
  end

  def clean_detail_field(import_row)
    details_fields = []
    type = import_row[TYPE_FIELD]

    if(use_field(import_row[DETAILS_FIELD]) && type != VISA_PURCHASE_TYPE)
      details_fields.push(import_row[DETAILS_FIELD])
    end

    if(use_field(import_row[PARTICULARS_FIELD]) && type != VISA_PURCHASE_TYPE && type != EFTPOS_PURCHASE_TYPE)
      details_fields.push(import_row[PARTICULARS_FIELD])
    end

    if(use_field(import_row[CODE_FIELD]) && type != EFTPOS_PURCHASE_TYPE)
      details_fields.push(import_row[CODE_FIELD])
    end

    if(use_field(import_row[REFERENCE_FIELD]) && type != VISA_PURCHASE_TYPE && type != EFTPOS_PURCHASE_TYPE)
      details_fields.push(import_row[REFERENCE_FIELD])
    end

    details_field_result = ""
    details_fields.each do |detail_field|
      details_field_result << "#{detail_field} "
    end

    details_field_result
  end

  def build_clean_row(import_row)
    check_required_fields(import_row)

    clean_row = []
    amount = import_row[AMOUNT_FIELD].to_f
    clean_row[0] = import_row[DATE_FIELD]
    clean_row[1] = amount
    clean_row[2] = amount > 0 ? CREDIT_VALUE : DEBIT_VALUE
    clean_row[3] = clean_detail_field(import_row)

    clean_row
  end
end
