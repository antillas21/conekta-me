Rails.application.routes.draw do
  resources :cards, defaults: { format: :json }
end
