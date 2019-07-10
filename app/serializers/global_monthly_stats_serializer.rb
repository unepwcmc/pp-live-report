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
    MAP_COVERAGE_PERCENTAGE_KEYS.each do |key|
      @data[key] = "%.1f" % @data[key]
    end
    
    @data
  end
end