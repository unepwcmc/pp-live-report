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

  def self.kba_timeseries
    kba_timeseries = {}
    csv_file = file_reader('Figure_7__chapter_3_PPR2018.csv')
    CSV.parse(csv_file, headers: true) do |row|
      year = row[0]
      row = row.to_hash.except!('Year')
      kba_timeseries[year] = row
    end
    kba_timeseries
  end

  def self.progress_level(filename, column)
    prog_lev = {}
    csv_file = file_reader(filename)
    CSV.parse(csv_file, headers: true) do |row|
      type = row[0]
      row = row.to_hash.except!(column)
      prog_lev[type] = row.each { |k, v| row[k] = v.to_f }
    end
    prog_lev
  end

  def self.per_pame_coverage
    country_perc('Figure 12 PAME_JUL18_REGIONAL.csv', 'PER_PAME_COVERAGE').select{|k,v| k != 'ABNJ'}
  end

  def self.count_of_pame_evaluations
    country_perc('Figure_13.csv', 'Count of PAME evaluations')
  end

  def self.governance_type
    gov_types = {}
    csv_file = file_reader('chapter 6 Box_10_first_figure (1).csv')
    CSV.parse(csv_file, headers: true) do |row|
      key = row[0]
      row = row.to_hash['Count'].to_i
      gov_types[key] = row
    end
    gov_types
  end

  def self.biogeographical_regions
    csv_file = file_reader('PPR-chapter4.csv')
    region_type = ''
    data = {}

    CSV.parse(csv_file, headers: true) do |row|
      unit = row["Biogeographical Unit"]
      if ['Ecoregions', 'Realms', 'Biomes', 'Provinces'].include?(unit)
        region_type = unit
        data[region_type] = []
        next
      end

      keys = (row.to_h.keys - ["Biogeographical Unit"])
      chart_rows = keys.map do |key|
        {
          percent: row[key].split("%").first.to_f,
          label: key
        }
      end
      theme = case unit
              when 'Terrestrial'
                'green'
              when 'Pelagic'
                'pelagic'
              else
                'blue'
              end
      chart = {
        chart_title: unit,
        theme: theme,
        rows: chart_rows
      }

      data[region_type] << chart
    end

    data.map do |title, charts|
      {
        title: title,
        charts: charts
      }
    end
  end

  def self.file_reader(file_name)
    File.read("#{Rails.root}/lib/data/file/#{file_name}")
  end

  private

  def self.country_perc(filename, column)
    country_perc = {}
    csv_file = file_reader(filename)
    CSV.parse(csv_file, headers: true) do |row|
      key = row[0]
      row = row.to_hash.slice(column)
      country_perc[key] = row[column].to_f.round(2)
    end
    country_perc
  end
end
