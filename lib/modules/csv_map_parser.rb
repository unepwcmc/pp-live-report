require 'csv'

module CsvMapParser
  extend self

  CATEGORICAL_MAP_STATS.each do |method_name, config|
    define_method(method_name) do
      categ_country_stats(config)
    end
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
