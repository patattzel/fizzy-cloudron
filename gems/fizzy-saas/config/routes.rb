Fizzy::Saas::Engine.routes.draw do
  namespace :signup do
    get "/" => "accounts#new"
    resources :accounts, only: %i[ new create ]
    get "/session" => "sessions#create" # redirect from Launchpad after mid-signup authentication
    resources :completions, only: %i[ new create ]
  end

  Queenbee.routes(self)
end
