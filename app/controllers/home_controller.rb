class HomeController < ApplicationController
  layout 'home'
  include YamlHelpers
  
  def index
    @data = load_yaml("lib/data/content/home.yml")
    global_monthly_stats = GlobalMonthlyStatsSerializer.new(CsvParser.global_monthly_stats).serialize
    @last_updated_date = global_monthly_stats['last_updated'] 


    @chapters = Array.new

    (1..10).each do |i|
      data = load_yaml("lib/data/content/chapter-#{i}.yml")

      @chapters.push({
        'title': data['menu_title'],
        'subtitle': data['subtitle'],
        'intro': data['intro'],
        'url': send("chapter_#{i}_path")
      })
    end 
    
    @chapters = @chapters.to_json
  end
end