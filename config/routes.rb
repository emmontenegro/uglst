# == Route Map (Updated 2014-06-16 08:50)
#
#                   Prefix Verb   URI Pattern                       Controller#Action
#                   status GET    /status(.:format)                 status#ping
#                          GET    /heartbeat.:format                heartbeat#ping {:format=>"txt"}
#            pages_pricing GET    /pages/pricing(.:format)          pages#pricing
#            pages_privacy GET    /pages/privacy(.:format)          pages#privacy
#           pages_security GET    /pages/security(.:format)         pages#security
#   pages_terms_of_service GET    /pages/terms_of_service(.:format) pages#terms_of_service
#          pages_changelog GET    /pages/changelog(.:format)        pages#changelog
#              user_groups GET    /user_groups(.:format)            user_groups#index
#                          POST   /user_groups(.:format)            user_groups#create
#           new_user_group GET    /user_groups/new(.:format)        user_groups#new
#          edit_user_group GET    /user_groups/:id/edit(.:format)   user_groups#edit
#               user_group GET    /user_groups/:id(.:format)        user_groups#show
#                          PATCH  /user_groups/:id(.:format)        user_groups#update
#                          PUT    /user_groups/:id(.:format)        user_groups#update
#                          DELETE /user_groups/:id(.:format)        user_groups#destroy
#                 profiles GET    /profiles(.:format)               profiles#index
#                          POST   /profiles(.:format)               profiles#create
#              new_profile GET    /profiles/new(.:format)           profiles#new
#             edit_profile GET    /profiles/:id/edit(.:format)      profiles#edit
#                  profile GET    /profiles/:id(.:format)           profiles#show
#                          PATCH  /profiles/:id(.:format)           profiles#update
#                          PUT    /profiles/:id(.:format)           profiles#update
#                          DELETE /profiles/:id(.:format)           profiles#destroy
#         new_user_session GET    /users/sign_in(.:format)          devise/sessions#new
#             user_session POST   /users/sign_in(.:format)          devise/sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)         devise/sessions#destroy
#            user_password POST   /users/password(.:format)         devise/passwords#create
#        new_user_password GET    /users/password/new(.:format)     devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)    devise/passwords#edit
#                          PATCH  /users/password(.:format)         devise/passwords#update
#                          PUT    /users/password(.:format)         devise/passwords#update
# cancel_user_registration GET    /users/cancel(.:format)           devise/registrations#cancel
#        user_registration POST   /users(.:format)                  devise/registrations#create
#    new_user_registration GET    /users/sign_up(.:format)          devise/registrations#new
#   edit_user_registration GET    /users/edit(.:format)             devise/registrations#edit
#                          PATCH  /users(.:format)                  devise/registrations#update
#                          PUT    /users(.:format)                  devise/registrations#update
#                          DELETE /users(.:format)                  devise/registrations#destroy
#                     root GET    /                                 user_groups#index
#

Rails.application.routes.draw do
  get '/status', to: 'status#ping'
  get '/heartbeat.:format', to: 'heartbeat#ping', constraints: { format: 'txt' }

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

  get 'pages/pricing'
  get 'pages/privacy'
  get 'pages/security'
  get 'pages/terms_of_service'
  get 'pages/changelog'

  resources :user_groups

  resources :profiles

  devise_for :users

  root 'user_groups#index'
end
