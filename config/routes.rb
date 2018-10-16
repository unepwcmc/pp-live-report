Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'  

  get '/chapter-1', to: 'chapters#chapter_1'
  get '/chapter-2', to: 'chapters#chapter_2'
  get '/chapter-3', to: 'chapters#chapter_3'
  get '/chapter-4', to: 'chapters#chapter_4'
  get '/chapter-5', to: 'chapters#chapter_5'
  get '/chapter-6', to: 'chapters#chapter_6'
  get '/chapter-7', to: 'chapters#chapter_7'
  get '/chapter-8', to: 'chapters#chapter_8'
  get '/chapter-9', to: 'chapters#chapter_9'
  get '/chapter-10', to: 'chapters#chapter_10'
end
