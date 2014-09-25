Rails.application.routes.draw do

  get 'session/create'

  get 'session/destroy'

root 'sites#landing'
get 'sites/index'
 get 'sites/about'
 get 'sites/post'
 post 'sites/post'
 get 'sites/landing'
end
