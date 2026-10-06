Rails.application.routes.draw do
  # No "invite anyone" page from Devise: invitations are sent from the admin space (and later the members page).
  # Only the pages to accept an invitation are kept.
  devise_for :users, skip: :invitations
  devise_scope :user do
    get "users/invitation/accept", to: "devise/invitations#edit", as: :accept_user_invitation
    patch "users/invitation", to: "devise/invitations#update", as: :user_invitation
    put "users/invitation", to: "devise/invitations#update"
  end

  # Admin space (admin account only): structures, and later categories.
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
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#home"
end
