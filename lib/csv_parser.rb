# Parses csv into rows
class CSVParser

  def initialize(csv_filename)
    @csv_filename = csv_filename
  end

  # parses the CSV file and returns an array of hashes
  def rows
    csv = CSV.open(@csv_filename, headers: true, header_converters: :symbol, converters: :all)
    csv.to_a.map { |row| row.to_hash }
  end

end
