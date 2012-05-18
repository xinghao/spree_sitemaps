Spree::Core::Engine.routes.draw do  
  #get "sitemap/index"
  #match 'sitemap.xml' => 'Sitemap#index'
  resources :sitemap
  # Add your extension routes here
end
