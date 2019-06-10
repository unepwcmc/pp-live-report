class GlobalMonthlyStatsSerializer
  
  def initialize(data)
    @data = data
  end

  def serialize
    @data['last_updated'] = Date.strptime(@data['last_updated'], '%m/%Y').strftime('%B %Y')
    @data
  end
end