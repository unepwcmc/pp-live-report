class ApplicationController < ActionController::Base
  before_action :set_data

  def set_data
    @shared_data = load_yaml("#{content_base_path}/shared.yml")
    @chapter_dates = ChapterDatesSerializer.new(CsvParser.chapter_dates).serialize
    @chapters_data = chapters_data
    @chapters = chapters
    set_updated_dates
  end

  def chapters_data
    (1..11).map do |i|
      load_yaml("#{content_base_path}/chapter-#{i}.yml", yaml_replace_data["chapter_#{i}"])
    end
  end

  def chapters
    @chapters_data.each_with_index.map do |chapter_data, index|
      {
        'title': chapter_data['menu_title'],
        'subtitle': chapter_data['subtitle'],
        'intro': chapter_data['intro'],
        'url': send("chapter_#{index + 1}_path")
      }
    end
  end

  def content_base_path
    'lib/data/content'
  end

  private

  def set_updated_dates
    dates = params[:controller] == 'chapters' ? 
      @chapter_dates[params[:action]] : 
      @chapter_dates['home']

    @last_updated_date = dates['last_updated'] 
    @next_updated_date = dates['next_updated'] 
  end

  def yaml_replace_data
    data = {
      'chapter_3' => GlobalMonthlyStatsSerializer.new(CsvParser.pp_global_monthly_stats).serialize,
      'chapter_6' => {}
    }

    data.keys.each do |chapter|
      data[chapter].merge!(@chapter_dates[chapter])
    end

    data
  end
end
