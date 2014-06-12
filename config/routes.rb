# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :companies  do
  collection do
    post :import
    post :change_root_project
    delete :destroy_all
  end
  resources :crmcomments
end

resources :clients  do
  collection do
    post :import
  end
  resources :crmcomments
end

resources :crm_actions do
  resources :crmcomments
end

