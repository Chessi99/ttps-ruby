Rails.application.routes.draw do
  get '/books/export', to: 'books#export_all'
  #resources :notes
  resources :books do
    member do
      get 'export'
    end
  end
  devise_for :users
  
  authenticated :user do
    ### Redireccion al listado de libros una vez logueado
    root 'books#index', as: :authenticated_root
  end
  
  devise_scope :user do
    ### En caso de no estar logueado redirecciona al login
    root to: 'devise/sessions#new'
  end

  resources :books do
    resources :notes do 
      member do
        get 'export'
      end
    end
  end
  
end
