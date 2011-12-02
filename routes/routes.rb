Ugs::Application.routes.draw do
  
  constraints(AdminWebsites) do 
    scope :module => 'admin', :as => 'admin' do
      resources :games do
        post 'search', :on => :collection
        get 'file'
        match 'infos/:info_id/screenshot' => 'games#screenshot', :as => 'screenshot'
        resource :head, :only => [:show,:edit,:update]
        resource :microcrea_info
        match 'current_spec' => 'specs#current', :as => 'current_spec'
      end
      resources :clusters, :except => :show
      resources :websites, :except => :show do
        post 'select', :on => :collection
      end
      resources :categories, :specs
      match '/screenshots/:size/:id.:format' => 'screenshots#file', :as => 'screenshot_file'
      match '/texts/to_slug' => 'texts#to_slug', :as => 'texts_to_slug'
      match '/statistics' => 'misc#statistics'
      root :to => 'misc#index'
    end
  end

  scope :module => 'websites' do
    public_map = Proc.new do
      match '/' => 'pages#index'
      match '/favicon.ico' => 'static#favicon'
      match '/s/:size/:slug.:format' => 'screenshots#show_for_game'
      match '/i/:size/:slug.:format' => 'screenshots#show_for_category'
      match '/g/:slug.:format' => 'games#send_game'
      match '/m/:file.:format' => 'static#show'
      match '/m/:directory/:file.:format' => 'static#show'
      match '/:category/' => 'categories#show', :format => //
      match '/:category/:game.:format' => 'games#show'
      match '/:category/:game/:vote/' => 'games#vote'
      match '/:page.:format' => 'pages#dynamic'
    end
    constraints(PrefixWebsites) do
      scope '/:prefix' do
        public_map.call
      end
    end
    constraints(HostWebsites) do
      public_map.call
    end
    constraints(PreviewWebsites) do
      scope '/:prefix', :prefix => /[^\/]+/ do
        public_map.call
      end
    end
  end
  
  match '/favicon.ico' => 'Admin::Misc#favicon'
  
end
