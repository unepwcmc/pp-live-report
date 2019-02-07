require 'csv'

module CsvMapParser
  def self.categ_country_stats(file_name)
    csv_file = file_reader(file_name)
    data = []
    CSV.parse(csv_file, headers: true) do |row|
      iso3 = row[0]
      categ_stats = row.to_hash.select{|s| s.include?('categorical')}.values.first
      data.append([iso3, categ_stats])
    end
    data
  end

  def self.file_reader(file_name)
    File.read("#{Rails.root}/lib/data/file/map/#{file_name}")
  end
end
