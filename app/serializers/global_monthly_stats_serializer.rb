class GlobalMonthlyStatsSerializer
  
  def initialize(data)
    @data = data
  end

  def serialize
    last_updated = Date.strptime(@data['last_updated'], '%m/%Y')

    @data['last_updated'] = last_updated.strftime('%B %Y')
    @data['last_updated_year'] = last_updated.strftime('%Y')
    
    @data
  end
end