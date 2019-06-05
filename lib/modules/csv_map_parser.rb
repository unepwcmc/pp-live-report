require 'csv'

module CsvMapParser
  def self.ch2_map2_categorical
    categ_country_stats('Ch2_Figure_4_categorical.csv')
  end

  def self.ch3_map1_percentage
    percentage_stats('Ch3_map_percentage.csv')
  end

  def self.ch5_map_categorical
    categ_country_stats('Ch5_Figure_10_categorical.csv')
  end

  def self.ch7_map1_categorical
    categ_country_stats('Ch7_Figure_14_categorical.csv')
  end

  def self.ch7_map2_categorical
    categ_country_stats('Ch7_Figure_15_AB_categorical.csv')
  end

  def self.ch7_map3_categorical
    categ_country_stats('Ch7_Figure_15_C_categorical.csv')
  end

  private
  
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

  def self.percentage_stats(file_name)
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
