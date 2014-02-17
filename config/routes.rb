# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :companies  do
  collection { post :import }
  resources :crmcomments
end

resources :clients  do
  collection { post :import }
  resources :crmcomments
end
