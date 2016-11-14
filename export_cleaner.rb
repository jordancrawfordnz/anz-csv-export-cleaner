require 'CSV'

class ExportCleaner
  def initialize(import_path, export_path)
      @import_path = import_path
      @export_path = export_path
  end

  def get_clean_header
    ["Date", "Amount", "Type", "Details"]
  end

  def get_clean_row(import_row)
    clean_row = Array.new
    amount = import_row["Amount"].to_f

    clean_row[0] = import_row["Date"]
    clean_row[1] = amount.abs
    clean_row[2] = amount > 0 ? "CR" : "DR"
    clean_row[3] = "#{import_row["Particulars"]} #{import_row["Code"]} #{import_row["Reference"]} - #{import_row["Details"]} #{import_row["Type"]}"
    clean_row
  end

  def build_clean_file
    unless (File.file?(@import_path))
      raise StandardError.new("No input file")
    end

    CSV.open(@export_path, "w",
      :write_headers=> true,
      :headers => get_clean_header) do |clean_csv|
      CSV.foreach(@import_path, :headers => true) do |import_row|
        clean_csv << get_clean_row(import_row)
      end
    end
  end
end
