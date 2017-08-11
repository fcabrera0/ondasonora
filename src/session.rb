require_relative 'base'
require 'digest'
require 'base64'

class SessionController < BaseController
  get '/logout' do
    cookies[:session] = ''
    redirect back
  end

  get '/registro' do
    unless @session.blank?
      redirect back
    end
    @title = 'Registro'
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
    slim :registro
  end

  post '/login' do
    unless @session.blank?
      redirect back
    end

    begin
      User.find_by(username: params[:username]) do |u|
        p = u.passwd
        if p[:hash] == Digest::SHA2.new(512).hexdigest(params[:password] + p[:salt])
          Session.create(
              user_id: u._id,
              ip: request.ip
          ) do |doc|
            cookies[:session] = doc._id.to_s
          end
        else
          redirect back, 'Contraseña incorrecta'
        end
      end
    rescue
      redirect back, 'Error al iniciar sesión'
    end
    redirect back
  end

  get '/ingresa' do
    unless @session.blank?
      redirect back
    end
    @title = 'Ingreso'
    slim :ingresa
  end

  post '/signup' do
    params.values.each do |v|
      if v.blank?
        redirect back, 'No pueden haber valores vacíos'
      end
    end

    if User.where(username: params[:username]).exists? ||
        User.where(email: params[:email]).exists? ||
        User.where(rut:params[:rut]).exists?
      redirect back, 'El usuario ya existe'
    end

    s = SecureRandom.base64
    p = params[:password] + s

    User.create(
        username: params[:username],
        email: params[:email],
        rut: params[:rut],
        passwd: {
            salt: s,
            hash: Digest::SHA2.new(512).hexdigest(p)
        },
        profile: {
          fullname: params[:fullname],
          region: params[:region],
          city: params[:city],
          address: params[:address]
        }
    )

    redirect '/'
  end
end
