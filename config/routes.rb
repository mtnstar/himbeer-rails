Rails.application.routes.draw do
  get 'assets/index'
  root 'assets#index'

  get 'devices' => 'devices#index'
  get 'devices/:id/toggle' => 'devices#toggle'
  get 'devices/:id/set_value' => 'devices#set_value'

end
