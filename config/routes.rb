# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :crmcomments do
  collection do
    post :import
  end
end

resources :attached_documents do
  member do
    get :download_file
    post :switch_locked
  end
end

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
  collection do
    post :import
  end
  resources :crmcomments
end

get 'crm_data', :to => 'data_handling#index'
get 'export_crm', :to => 'data_handling#full_export'

