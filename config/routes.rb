# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :companies  do
  collection { post :import }
end

resources :clients  do
  collection { post :import }
end

resources :crmcomments