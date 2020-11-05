Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'  

  # Irrespective of how many view files are present in the /chapters directory
  Dir.children('app/views/chapters').each do |i|
    name = File.basename(i, ".html.erb")
    get "/#{name.gsub(/_/, '-')}", to: "chapters##{name}"
  end
end
