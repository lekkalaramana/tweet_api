Rails.application.routes.draw do
	# default_url_options :host => ENV['SITE_ROOT']
  scope '/api' do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      sessions: 'sessions'
    }
    namespace :v1 do
      resources :tweets
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
