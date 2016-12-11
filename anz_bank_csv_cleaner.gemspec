Gem::Specification.new do |s|
  s.name        = "anz_bank_csv_cleaner"
  s.version     = "0.1"
  s.date        = "2016-12-11"
  s.summary     = "Produces a cleaner version of the ANZ Bank CSV export for easier transaction identification."
  s.description = "ANZ Bank's CSV export contains many fields, making it difficult to identify transactions. This Gem simplifies these fields, making the file easier to use."
  s.authors     = ["Jordan Crawford"]
  s.email       = "jordan@crawford.kiwi"
  s.files       = ["lib/anz_bank_csv_cleaner.rb"]
end
