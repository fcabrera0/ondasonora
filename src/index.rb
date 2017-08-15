require_relative 'base'
require 'slim'

class IndexController < BaseController
  get '/' do
    @title = 'Inicio'
    @projects = Project.where(status: 1)
    @payments = Payment.where(status: 1)
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