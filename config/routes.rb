Refinery::Core::Engine.routes.draw do
  if Refinery::Settings.enable_interface
    namespace :admin, :path => Refinery::Core.backend_route do
      resources :settings, :except => :show do
        collection do
          post :multi_update
        end
      end
    end
  end
end
