
Rails.application.routes.draw do
  resources :pucs
  resources :banks
  resources :movements

  root to: redirect('home')
  devise_for :users, controllers: {
    :registrations => "users/registrations"
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/home', to: 'movements#home', as: 'home'
  get '/show', to: 'movements#show', as: 'show'
  get '/cupon', to: 'movements#_cupones_header', as: '_cupones_header'
  get '/webmaster', to: 'application#_superadmin_header', as: '_superadmin_header'

  get '/todos', to: 'movements#see_all', as: 'see_all'
  get '/weeks', to: 'movements#see_weeks', as: 'see_weeks'
  get '/months', to: 'movements#see_months', as: 'see_months'
  get '/tiempo', to: 'movements#see_tiempo', as: 'see_tiempo'

  get '/redes', to: 'movements#redes', as: 'redes'
  get '/chat', to: 'movements#rs_chat', as: 'rs_chat'
  get '/agenda', to: 'movements#rs_agenda', as: 'rs_agenda'
  get '/eventos', to: 'movements#rs_eventos', as: 'rs_eventos'
  get '/notas', to: 'movements#rs_notas', as: 'rs_notas'

  get '/datos', to: 'movements#data', as: 'data'
  get '/bancos', to: 'banks#index', as: 'bancos'
  get '/bancol', to: 'banks#b_bancol', as: 'b_bancol'
  get '/bogota', to: 'banks#b_bogota', as: 'b_bogota'
  get '/daviv',  to: 'banks#b_daviv', as: 'b_daviv'

  get '/contab', to: 'movements#contab', as: 'contab'
  get '/finanzas', to: 'movements#finanzas', as: 'finanzas'
  get '/credit', to: 'movements#credit', as: 'credit'

  get '/movmed', to: 'movements#movmed', as: 'movmed'
  get '/leyes', to: 'movements#n_leyes', as: 'n_leyes'
  get '/normas', to: 'movements#normas', as: 'normas'
  get '/pp', to: 'movements#movm_pp', as: 'movm_pp'
  get '/runt', to: 'movements#n_runt', as: 'n_runt'

  get '/flota', to: 'movements#tr_flota', as: 'tr_flota'
  get '/andaluz', to: 'movements#vx_andaluz', as: 'vx_andaluz'
  get '/athos', to: 'movements#vx_athos', as: 'vx_athos'
  get '/athos_bitac', to: 'movements#vx_athos_bitac', as: 'vx_athos_bitac'
  get '/athos_matric', to: 'movements#vx_athos_matric', as: 'vx_athos_matric'
  get '/taxis', to: 'movements#vx_taxis', as: 'vx_taxis'

  get '/coltrans', to: 'movements#tr_coltrans', as: 'tr_coltrans'
  get '/dimax', to: 'movements#vc_dimax_', as: 'vc_dimax_'
  get '/dimax_agree', to: 'movements#vc_dmx_contratos', as: 'vc_dmx_contratos'
  get '/dimax_bitac', to: 'movements#vc_dimax_bitac', as: 'vc_dimax_bitac'
  get '/dimax_matric', to: 'movements#vc_dimax_matric', as: 'vc_dimax_matric'

  get '/autos', to: 'movements#vc_autos', as: 'vc_autos'
  get '/golf', to: 'movements#vc_golf_', as: 'vc_golf_'
  get '/piaggio', to: 'movements#vm_piaggio', as: 'vm_piaggio'

  get '/taller', to: 'movements#tr_taller', as: 'tr_taller'
  get '/mec_aut', to: 'movements#tr_tutors', as: 'tr_tutors'

  as :user do
    get 'admin', to: 'devise/sessions#new'
    get 'reset_password', to: 'devise/passwords#new'
  end

  scope(path_names: { new: 'nuevo', edit: 'editar' }) do
  end
end
