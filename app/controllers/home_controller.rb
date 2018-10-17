class HomeController < ApplicationController
  layout 'home'
  
  def index
    @data = YAML.load(File.open("#{Rails.root}/lib/data/content/home.yml", 'r'))    
  end
end