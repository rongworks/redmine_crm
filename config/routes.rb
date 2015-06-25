# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'crm_app', to:'crm_main#index'

namespace :api, defaults: {format: :json} do
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
      post :reset_primary_contacts
      post :info
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
    member do
      get :export_addresses
      post :add_companies
    end
    resources :crmcomments
    resources :crm_reminders
  end

  resources :crm_reminders do
    member do
      post :close
    end
  end
end

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
    post :reset_primary_contacts
    post :info
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
  member do
    get :export_addresses
    post :add_companies
  end
  resources :crmcomments
  resources :crm_reminders
end

resources :crm_reminders do
  member do
    post :close
  end
end
get 'crm_data', :to => 'data_handling#index'
get 'export_crm', :to => 'data_handling#full_export'

