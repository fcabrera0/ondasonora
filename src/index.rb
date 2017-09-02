require_relative 'base'
require 'slim'

class IndexController < BaseController
  get '/' do
    @title = 'Inicio'

    begin
      @payments = Payment.where(status: 1)
    rescue
      @payments = []
    end

    begin
      @projects = Project.where(status: 1)
    rescue
      @projects = []
    end

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