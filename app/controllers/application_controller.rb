class ApplicationController < ActionController::Base
  before_action :set_data

  def set_data
    @chapters_data = chapters_data
    @chapters = chapters(@chapters_data)
  end

  def chapters_data
    global_monthly_stats = GlobalMonthlyStatsSerializer.new(CsvParser.global_monthly_stats).serialize
    chapters_data = []

    (1..10).each do |i|
      yaml_data = load_yaml("#{content_base_path}/chapter-#{i}.yml", global_monthly_stats)

      chapters_data.push(yaml_data)
    end
    
    chapters_data
  end

  def chapters(chapters_data)
    chapters = []

    (1..10).each do |i|
      chapter_data = chapters_data[i-1]

      chapters.push({
        'title': chapter_data['menu_title'],
        'subtitle': chapter_data['subtitle'],
        'intro': chapter_data['intro'],
        'url': send("chapter_#{i}_path")
      })
    end 
    
    chapters
  end

  def content_base_path
    'lib/data/content'
  end
end
