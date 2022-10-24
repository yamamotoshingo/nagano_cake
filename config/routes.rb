Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  scope module: :public do
  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'
  resources :items, only: [:index, :show]
  get '/customers/my_page' => "customers#show", as: 'customer_my_page'
  get '/customers/information/edit' => "customers#edit", as: 'edit_customer_information'
  patch '/customers/information' => "customers#update", as: 'customer_information'
  resources :customers, only: [] do
    collection do
      get 'confirm'
      patch 'withdrawal'
    end
  end
  resources :cart_items, only: [:index, :update, :destroy, :create] do
    collection do
      delete 'destroy_all'
    end
  end
  resources :orders, only: [:new, :index, :show, :create] do
    collection do
      post 'confirm'
      get 'completion'
    end
  end
  resources :addresses, only: [:index, :edit, :create, :update, :destroy]
  end

  namespace :admin do
    get '' => 'homes#top'
    resources :items, only: [:index, :new, :show, :edit, :create, :update]
    resources :genres, only: [:index, :edit, :create, :update]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:show, :update]
    resources :order_items, only: [:update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
