require_relative 'base'

class DashController < BaseController
  get '/dash' do
    if @session.blank?
      redirect '/ingresa'
    end
    @title = 'Dashboard'
    @region = [
        { value: 15, name: 'Arica y Parinacota' },
        { value: 1, name: 'Tarapacá' },
        { value: 2, name: 'Antofagasta' },
        { value: 3, name: 'Atacama' },
        { value: 4, name: 'Coquimbo' },
        { value: 5, name: 'Valparaíso' },
        { value: 13, name: 'Metropolitana' },
        { value: 6, name: "O'Higgins" },
        { value: 7, name: 'Maule' },
        { value: 8, name: 'Bío Bío' },
        { value: 9, name: 'Araucanía' },
        { value: 14, name: 'Los Ríos' },
        { value: 10, name: 'Los Lagos' },
        { value: 11, name: 'Aysén' },
        { value: 12, name: 'Magallanes' },
    ]
    @payments = Payment.where(user_id: BSON::ObjectId.from_string(@user.id))
    @projects = Project.where(by: BSON::ObjectId.from_string(@user.id))
    slim :dash
  end

  post '/dash/perfil' do
    if @session.blank?
      redirect '/ingresa'
    end
    @user.email = params[:email]
    @user.profile[:region] = params[:region]
    @user.profile[:city] = params[:city]
    @user.profile[:address] = params[:address]
    @user.save

    redirect back
  end
end