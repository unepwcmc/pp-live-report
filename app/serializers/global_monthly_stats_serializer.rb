class GlobalMonthlyStatsSerializer

  def initialize(data)
    @data = data
  end

  def serialize
    last_updated = Date.strptime(@data['last_updated'], '%d/%m/%Y')

    @data['last_updated'] = last_updated.strftime('%B %Y')
    @data['last_updated_year'] = last_updated.strftime('%Y')
    map_coverage_percentages_to_2_dp

    @data
  end

  private
    def map_coverage_percentages_to_2_dp
      [
        'national_waters_pa_coverage_percentage',
        'total_ocean_pa_coverage_percentage',
        'total_land_pa_coverage_percentage',
        'high_seas_pa_coverage_percentage'
      ].each do |key|
        @data[key] = "%.1f" % @data[key]
      end
    end
end