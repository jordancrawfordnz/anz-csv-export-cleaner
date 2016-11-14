require_relative 'export_cleaner'

if (ARGV.length != 1) then
  puts "ruby clean-exports.rb [path to import CSV] [path to export CSV]"
  exit
end

import_path = ARGV[0]
export_path = "#{import_path.split('.')[-2]}.cleaned.csv"

export_cleaner = ExportCleaner.new(import_path, export_path)
begin
  export_cleaner.build_clean_file
rescue StandardError => message
  puts "No file: #{message}"
  exit
end

puts "Export complete."
