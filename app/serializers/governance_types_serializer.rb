class GovernanceTypesSerializer

  def initialize(component_data)
    @component_data = component_data
  end

  def serialize
    column_chart_data = []

    @component_data.each do |key, value|
      column_chart_data << {
        label: key,
        value: value
      }
    end

    @column_chart_data = column_chart_data.to_json
  end
end