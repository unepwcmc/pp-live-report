require 'csv'
CATEGORICAL_MAP_STATS = {
  ch2_map2_categorical: 'Ch2_Figure_4_categorical.csv',
  ch5_map_categorical: 'Ch5_Figure_10_categorical.csv',
  ch7_map1_categorical: 'Ch7_Figure_14_categorical.csv',
  ch7_map2_categorical: 'Ch7_Figure_15_AB_categorical.csv',
  ch7_map3_categorical: 'Ch7_Figure_15_C_categorical.csv',
}

module CsvMapParser
  extend self

  CATEGORICAL_MAP_STATS.each do |method_name, filename|
    define_method(method_name) do
      categ_country_stats(filename)
    end
  end

  def ch3_map1_percentage
    percentage_stats('Ch3_map_percentage.csv')
  end

  private
  
  def categ_country_stats(file_name)
    csv_file = file_reader(file_name)
    data = []
    CSV.parse(csv_file, headers: true) do |row|
      iso3 = row[0]
      categ_stats = row.to_hash.select{|s| s.include?('categorical')}.values.first
      data.append([iso3, categ_stats])
    end
    data
  end

  def percentage_stats(file_name)
    csv_file = file_reader(file_name)
    data = {}
    CSV.parse(csv_file, headers: true) do |row|
      data[row[0]] = row[1]
    end
    data
  end

  def self.file_reader(file_name)
    File.read("#{Rails.root}/lib/data/file/map/#{file_name}")
  end
end
