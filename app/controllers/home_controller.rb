class HomeController < ApplicationController
  layout 'home'
  include YamlHelpers
  
  def index
    @data = load_yaml("#{content_base_path}/home.yml")
    global_monthly_stats = GlobalMonthlyStatsSerializer.new(CsvParser.global_monthly_stats).serialize
    @last_updated_date = global_monthly_stats['last_updated']
  end
end