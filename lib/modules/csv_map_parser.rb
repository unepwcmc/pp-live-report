require 'csv'
# a boundary of 0 will make the first category only those with a value of 0 
# (used for no assessment/no data categories)
CATEGORICAL_MAP_STATS = {
  ch2_map2_categorical: {
    boundaries: [0,5,10,17],
    header_name: 'percentage_pa_land_cover',
    csv: 'chapter2_national_pa_statistics.csv'
  },
  ch5_map_categorical: {
    boundaries: [0,10,30,60],
    header_name: 'pame_percentage_pa_land_cover',
    csv: 'chapter2_national_pa_statistics.csv'
  },
  ch7_map1_categorical: {
    boundaries: [4,8,12,17,25],
    header_name: 'ProtConn_B',
    csv: 'chapter7_national_connectivity_perccov_mar20.csv'
  },
  ch7_map2_categorical: {
    csv: 'Ch7_Figure_15_AB_categorical.csv'
  },
  ch7_map3_categorical: {
    csv: 'Ch7_Figure_15_C_categorical.csv'
  }
}

module CsvMapParser
  extend self

  CATEGORICAL_MAP_STATS.each do |method_name, config|
    define_method(method_name) do
      categ_country_stats(config)
    end
  end

  def ch3_map1_percentage
    percentage_stats('chapter3_global_kba_statistics.csv')
  end

  private
  
  def categ_country_stats(config)
    csv_file = file_reader(config[:csv])
    data = []

    CSV.parse(csv_file, headers: true) do |row|
      iso3 = row[0]
      categ_stat = category(row.to_hash, config)
      
      data.append([iso3, categ_stat])
    end

    data
  end

  def category(row_hash, config)
    category = 0

    if config.key?(:boundaries)
      percentage = row_hash.select{|s| s == config[:header_name]}.values.first

      config[:boundaries].each do |boundary|
        category += 1 if percentage.to_f > boundary
      end
    else
      category = row_hash.select{|s| s.include?('categorical')}.values.first
    end
    
    category
  end

  def percentage_stats(file_name)
    csv_file = file_reader(file_name)
    data = {}
    
    CSV.parse(csv_file, headers: true) do |row|
      data[row[0]] = "#{row[1]}%"
    end

    data
  end

  def self.file_reader(file_name)
    File.read("#{Rails.root}/lib/data/file/map/#{file_name}")
  end
end
