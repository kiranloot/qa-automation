Lootcrate::Application.routes.draw do
  require 'sidekiq/web'
  authenticate :admin_user do
    mount Sidekiq::Web, at: '/admin/hidden_sidekiq'
  end

  # TODO - find out where these are used
  get 'payment_completed/index', :as => 'payment_completed'
  get 'content/gold'
  get 'content/silver'
  get 'content/platinum'
  # TODO - resolve duplicates
  get 'how_it_works/index'
  get 'how_it_works', to: 'how_it_works#index'
  # TODO - make sure there are path/index path also


  # App Pages ===================================================================
  get 'welcome/index'
  get 'welcome',           to: 'welcome#index'
  get 'epic',              to: 'welcome#index'      #here for Wider Funnel / Optimizely purposes. For public use.
  get 'summerofarcade',    to: 'welcome#index'
  get 'about_us/index'
  get 'about_us',          to: 'about_us#index'
  get 'contact/index'
  get 'contact',           to: 'contact#index'
  get 'contest_winners/index'
  get 'contest_winners',   to: 'contest_winners#index'
  # WIP: Bryce - 02/18/2015
  # get 'fb/index'
  # get 'fb',                to: 'fb#index'
  get 'gifts/index'
  get 'gifts',             to: 'gifts#index'
  get 'community/index'
  get 'community',         to: 'community#index'
  get 'community/hidepostano',   to: 'community#hidepostano'
  get 'community/showpostano',   to: 'community#showpostano'
  get 'privacy_policy/index'
  get 'privacy_policy',    to: 'privacy_policy#index'
  get 'review/index'
  get 'review',            to: 'review#index'
  get 'terms_conditions/index'
  get 'terms_conditions',  to: 'terms_conditions#index'
  get 'past_crates/index'
  get 'past_crates',       to: 'past_crates#index'
  get 'partner',           to: 'partner#new'
  get 'partners',          to: 'partner#new'
  get 'thankyou',          to: 'partner#thankyou'
  get 'media_inquiries',   to: 'media_inquiries#new'
  get 'sold_out',          to: 'sold_out#index'
  get 'amiibo',            to: 'amiibo#index'
  get 'surveys/cancellation', to: 'surveys#cancellation'

  get 'international/index'
  get 'international',     to: 'international#index'

  get 'join',              to: 'subscriptions#index'
  get 'getloot',           to: 'subscriptions#index'

  get 'australia',         to: 'welcome#international', defaults: { country: "AU" }
  get 'au',                to: 'welcome#international', defaults: { country: "AU" }
  get 'canada',            to: 'welcome#international', defaults: { country: "CA" }
  get 'ca',                to: 'welcome#international', defaults: { country: "CA" }
  get 'germany',           to: 'welcome#international', defaults: { country: "DE" }
  get 'de',                to: 'welcome#international', defaults: { country: "DE" }
  get 'denmark',           to: 'welcome#international', defaults: { country: "DK" }
  get 'dk',                to: 'welcome#international', defaults: { country: "DK" }
  get 'finland',           to: 'welcome#international', defaults: { country: "FI" }
  get 'fi',                to: 'welcome#international', defaults: { country: "FI" }
  get 'france',            to: 'welcome#international', defaults: { country: "FR" }
  get 'fr',                to: 'welcome#international', defaults: { country: "FR" }
  get 'ireland',           to: 'welcome#international', defaults: { country: "IE" }
  get 'ie',                to: 'welcome#international', defaults: { country: "IE" }
  get 'netherlands',       to: 'welcome#international', defaults: { country: "NL" }
  get 'nl',                to: 'welcome#international', defaults: { country: "NL" }
  get 'norway',            to: 'welcome#international', defaults: { country: "NO" }
  get 'no',                to: 'welcome#international', defaults: { country: "NO" }
  get 'new_zealand',       to: 'welcome#international', defaults: { country: "NZ" }
  get 'newzealand',        to: 'welcome#international', defaults: { country: "NZ" }
  get 'nz',                to: 'welcome#international', defaults: { country: "NZ" }
  get 'sweden',            to: 'welcome#international', defaults: { country: "SE" }
  get 'se',                to: 'welcome#international', defaults: { country: "SE" }
  get 'united_kingdom',    to: 'welcome#international', defaults: { country: "GB" }
  get 'unitedkingdom',     to: 'welcome#international', defaults: { country: "GB" }
  get 'uk',                to: 'welcome#international', defaults: { country: "GB" }
  get 'gb',                to: 'welcome#international', defaults: { country: "GB" }

  # Looter Experience
  get 'experience',     to: 'monthly#experience'  #overwritten every month

  # Monthly Reviews / Contests ==================================================
  get 'eightbit',       to: 'monthly#eightbit'
  get 'wildfire/index', to: 'monthly#wildfire'
  get 'red',            to: 'monthly#wildfire'
  get 'blue',           to: 'monthly#wildfire'
  get 'holiday',        to: 'monthly#holiday2012'
  get 'resolution',     to: 'monthly#resolution'
  get 'contest',        to: 'monthly#contest'
  get 'qr',             to: 'monthly#qr'
  get 'thirtylives',    to: 'monthly#thirtylives'
  get 'survive',        to: 'monthly#survive'
  get 'battlecrateinstructions', to: 'monthly#battlecrateinstructions'
  get 'munnycontest',   to: 'monthly#munnycontest'
  get 'cybercrate',     to: 'monthly#cybercrate'
  get 'covertcontest',  to: 'monthly#covert_contest'
  get 'covertops',      to: 'monthly#covertops'
  get 'covertloot',     to: 'monthly#covertloot'
  get 'buildanarmy',    to: 'monthly#buildanarmy'
  get 'exp/cyber',          to: 'monthly#cyber_exp'
  post 'covert_questions', to: 'monthly#covert_questions'
  get 'marvelus',        to: 'monthly#marvelus'
  get 'con/cyber',      to: 'monthly#cyber_contest'

  # Root ========================================================================
  root to: 'welcome#index'
  authenticated :user do
    root :to => 'welcome#index', :as => "authenticated_root"
  end

  # Webhooks ====================================================================
  post 'hooks/chargify', to:'web_hooks/chargify#dispatcher'
  post 'hooks/chargify_braintree', to:'web_hooks/chargify#dispatcher'
  post 'hooks/recurly', to:'web_hooks/recurly#dispatcher'

  # Resources ===================================================================
  resources :billing_addresses,  only: [:update], controller: 'billing_address'
  resources :payment_method, only: [:update], controller: :payment_method
  resources :shipping_addresses, only: [:edit, :update], controller: 'shipping_address'
  get 'address/states', to: 'shipping_address#states'
  #put 'shipping_address/:id', to: 'shipping_address#update', as: 'update_shipping_address'

  resources :subscriptions, except: [:new, :edit, :show, :destroy] do
    collection { put :update_summary }
    member do
      put :cancel_at_end_of_period
      put :undo_cancellation_at_end_of_period
      put :reactivate
      get :reactivation
      put :apply_coupon_for_reactivation
      get :cancellation
      put :upgrade
      get '/upgrade/preview', action: :upgrade_preview
      put :skip_a_month
      get :skip_a_month_preview
      get :skip_a_month_success
    end
  end

  scope ":plan" do
    namespace 'level_up' do
      resources :checkouts, only: [:new, :create] do
        collection { put :update_summary }
      end
    end
    resources :checkouts, only: [:new, :create] do
      collection { put :update_summary }
    end
    resources :express_checkouts, only: [:new, :create] do
      #get 'checkouts/alt'
      collection { put :update_summary }
    end
  end

  # New Subscriptions
  get 'level_up', to: 'level_up#index'

  resources :plans, only: [:show]

  resources :user_accounts, except: [:create, :new, :edit, :destroy, :show] do
    post :update_password
  end
  post '/user_accounts/update_email', to: 'user_accounts#update_email', as: :user_account_update_email

  # TODO: Clean this.
  get 'user_accounts/subscription/:id', to: 'user_accounts#show', as: 'user_accounts_subscription'
  get 'user_accounts/store_credits', to: 'user_accounts#store_credits', as: 'user_accounts_store_credits'
  get 'user_accounts/subscriptions', to: 'user_accounts#subscriptions', as: 'user_accounts_subscriptions'
  get 'user_accounts/account_settings', to: 'user_accounts#index', as: 'user_accounts_account_settings'

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users,
  path_names:  { sign_in: 'login', sign_out: 'logout' },
  controllers: { registrations: 'registrations', sessions: 'sessions', passwords: 'passwords',
    omniauth_callbacks: 'users/omniauth_callbacks' }

#  resources :users
  devise_scope :user do
    # This was breaking due to PR 420.  Fixed by removing custom devise failure
    # get '/validate_cookie',            to: 'registrations#validate_cookie'
    get 'legacy_account/confirmation', to: 'passwords#edit'
  end

  post 'friendbuy_share', to: 'friendbuy_webhooks#share'
  post 'friendbuy_conversion', to: 'friendbuy_webhooks#conversion'
  get 'share',            to: 'friendbuy_share#show'
  post 'newsletter_signup', to: 'newsletter_signups#create'

  # LC Events
  get 'kiosk', to: 'loot_crate_kiosks#show'

  # Affiliates ==================================================================
  get '/:affiliate_name', to: 'affiliateforwards#get_affiliate'
end
