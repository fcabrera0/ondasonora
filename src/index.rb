require_relative 'base'
require 'slim'

class IndexController < BaseController
  set :port, 3000
  
  get '/' do
    @title = 'Inicio'
    @projects = Project.where(status: 1)
    slim :inicio
  end

  get '/error' do
    @title = 'Página no encontrada'
    slim :error
  end

  get '*' do
    redirect '/error'
  end
end