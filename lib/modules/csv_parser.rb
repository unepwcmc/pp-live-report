require 'csv'

module CsvParser
  def self.global_coverage_stats
    global_cov = []
    csv_file = file_reader('Ch2_Fig2_Global_Coverage_Stats.csv')
    CSV.parse(csv_file, headers: true) do |row|
      global_cov << row.to_hash
    end
    global_cov
  end

  def self.timeseries
    timeseries = {}
    csv_file = file_reader('Ch2_Fig3_Global_PA_Timeseries.csv')
    CSV.parse(csv_file, headers: true) do |row|
      year = row[0]
      row = row.to_hash.except!('Year')
      timeseries[year] = row.each { |k, v| row[k] = v.delete(',').to_i / 1000000.00 }
    end
    timeseries
  end

  def self.file_reader(file_name)
    File.read("#{Rails.root}/lib/data/file/#{file_name}")
  end
end
