MAP_COVERAGE_PERCENTAGE_KEYS = [
  'national_waters_pa_coverage_percentage',
  'total_ocean_pa_coverage_percentage',
  'total_land_pa_coverage_percentage',
  'high_seas_pa_coverage_percentage'
]

class GlobalMonthlyStatsSerializer

  def initialize(data)
    @data = data
  end

  def serialize
    last_updated = Date.strptime(@data['last_updated'], '%d/%m/%Y')

    @data['last_updated'] = last_updated.strftime('%B %Y')
    @data['last_updated_year'] = last_updated.strftime('%Y')
    map_coverage_percentages_to_1_dp

    @data
  end

  private
    def map_coverage_percentages_to_1_dp
      MAP_COVERAGE_PERCENTAGE_KEYS.each do |key|
        @data[key] = "%.1f" % @data[key]
      end
    end
end