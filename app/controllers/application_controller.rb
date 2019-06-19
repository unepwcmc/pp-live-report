class ApplicationController < ActionController::Base
  before_action :set_main_nav

  def set_main_nav
    main_nav = Array.new

    (1..10).each do |i|
      data = load_yaml("#{content_base_path}/chapter-#{i}.yml")

      main_nav.push({
        'title': data['menu_title'],
        'subtitle': data['subtitle'],
        'url': send("chapter_#{i}_path")
      })
    end 
    
    @main_nav = main_nav
  end

  def content_base_path
    'lib/data/content'
  end
end
