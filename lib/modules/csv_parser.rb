require 'csv'

module CsvParser
  def self.chapter_dates
    dates = {}
    CSV.parse(file_reader(CSV_CHAPTER_DATES), headers: true) do |row|
      dates["chapter_#{row['chapter']}"] = {
        'last_updated' => row['last_updated'],
        'next_updated' => row['next_updated']
      }
    end
    dates
  end

  def self.pp_global_monthly_stats
    stats = {}
    CSV.parse(file_reader(CSV_CH3_MAP_PA_GLOBAL), headers: true) do |row|
      stats[row['type']] = row['value']
    end
    stats
  end

  def self.timeseries
    timeseries = {}
    csv_file = file_reader(CSV_CH3_TIMESERIES)
    CSV.parse(csv_file, headers: true) do |row|
      year = row[0]
      row = row.to_hash.except!('Year')
      timeseries[year] = row.each { |k, v| row[k] = v.delete(',').to_i / 1000000.00 }
    end
    timeseries
  end

  def self.kba_timeseries
    kba_timeseries = {}
    csv_file = file_reader(CSV_CH5_TIMESERIES_KBA)
    CSV.parse(csv_file, headers: true) do |row|
      year = row[0]
      row = row.to_hash.except!('Year')
      kba_timeseries[year] = row
    end
    kba_timeseries
  end

  def self.per_pame_coverage
    country_perc(CSV_CH6_PAME_REGIONAL_PERCENT, 'PER_PAME_COVERAGE').select{|k,v| k != 'ABNJ'}
  end

  def self.count_of_pame_evaluations
    country_perc(CSV_CH6_PAME_REGIONAL_COUNT, 'Count of PAME evaluations')
  end

  def self.biogeographical_regions
    csv_file = file_reader(CSV_CH4_ECOREGIONS)
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
          percent_oecm: get_oecm_percent(row[key]),
          label: key,
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
    File.read("#{Rails.root}/public/file/#{file_name}")
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

  def self.get_oecm_percent(string)
    (string.include? 'oecm') ? string.split('oecm').last.to_f : 0
  end
end
