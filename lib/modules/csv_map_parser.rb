require 'csv'
# a boundary of 0 will make the first category only those with a value of 0 
# (used for no assessment/no data categories)
CATEGORICAL_MAP_STATS = {
  ch3_map2_categorical: {
    boundaries: [0,5,10,17],
    header_name: 'percentage_pa_land_cover',
    csv: CSV_CH3_PA_NATIONAL
  },
  ch6_map_categorical: {
    boundaries: [0,10,30,60],
    header_name: 'pame_percentage_pa_land_cover',
    csv: CSV_CH3_PA_NATIONAL
  },
  ch8_map1_categorical: {
    boundaries: [4,8,12,17,25],
    header_name: 'ProtConn_B',
    csv: CSV_CH8_NATIONAL_CONNECTIVITY
  },
  ch8_map2_categorical: {
    csv: CSV_CH8_AB_CATEGORICAL
  },
  ch8_map3_categorical: {
    csv: CSV_CH8_C_CATEGORICAL
  }
}

module CsvMapParser
  extend self

  CATEGORICAL_MAP_STATS.each do |method_name, config|
    define_method(method_name) do
      categ_country_stats(config)
    end
  end

  def ch5_map1_percentage
    percentage_stats(CSV_CH5_GLOBAL_KBA)
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
    File.read("#{Rails.root}/public/file/map/#{file_name}")
  end
end
