Rails.application.routes.draw do

  get 'session/create'

  get 'session/destroy'

root 'sites#index'
get 'sites/index'
 get 'sites/about'
 get 'sites/post'
 post 'sites/post'
end
