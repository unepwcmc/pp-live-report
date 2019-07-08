class HomeController < ApplicationController
  layout 'home'
  include YamlHelpers
  
  def index
    @data = load_yaml("#{content_base_path}/home.yml")
  end
end