Rails.application.routes.draw do
  resources :cards, only: [:create], defaults: { format: :json }
  resources :charges, only: [:create, :show], defaults: { format: :json }
end
