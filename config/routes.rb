Rails.application.routes.draw do
  # No "invite anyone" page from Devise: invitations are sent from the admin space (and later the members page).
  # Only the pages to accept an invitation are kept.
  devise_for :users, skip: :invitations
  devise_scope :user do
    get "users/invitation/accept", to: "devise/invitations#edit", as: :accept_user_invitation
    patch "users/invitation", to: "devise/invitations#update", as: :user_invitation
    put "users/invitation", to: "devise/invitations#update"
  end

  # Listings (surpluses). Withdrawing keeps the listing in the history of the structure.
  resources :listings, only: %i[index new create show edit update] do
    patch :withdraw, on: :member
  end
  # "Mes échanges": the listings of my structure (and later its reservations).
  get "exchanges", to: "exchanges#index"

  # "Ma structure" page of the signed-in person, "Mon compte" and the password change.
  resource :organization, only: %i[show edit update]
  resource :account, only: %i[edit update]
  resource :account_password, only: %i[edit update]
  # "Membres" page of a structure, for its managers.
  resources :members, only: %i[index create] do
    member do
      patch :promote
      patch :demote
      patch :deactivate
      patch :reactivate
      post :resend_invitation
    end
  end

  # Admin space (admin account only): structures and categories.
  namespace :admin do
    root to: "organizations#index"
    resources :organizations, only: %i[index new create edit update] do
      member do
        patch :deactivate
        patch :reactivate
      end
      # Invite another manager, or send an invitation again.
      resources :manager_invitations, only: :create
    end
    resources :categories, only: %i[index new create edit update] do
      patch :move, on: :member # ?direction=up or down
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # Home page: the listings that can be reserved.
  root "listings#index"
end
