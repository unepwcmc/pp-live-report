class HomeController < ApplicationController
  layout 'home'
  
  def index
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/home.yml", 'r'))

    @chapters = Array.new

    (1..10).each do |i|
      data = YAML.load(File.open("#{Rails.root}/lib/data/content/chapter-#{i}.yml", 'r'))

      @chapters.push({
        'title': data['title'],
        'subtitle': data['subtitle'],
        'intro': data['intro'],
        'url': send("chapter_#{i}_path")
      })
    end 
    
    @chapters = @chapters.to_json
  end
end