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
    return {
      status: 1,
      msg: ''
    }.to_json if not @session.blank?

    @json = JSON.parse(request.body.read, :symbolize_names => true)
    ret = {
        status: 0
    }

    if @json[:username].blank? || @json[:password].blank?
      ret = {
          status: 2,
          msg: 'Credenciales vacías'
      }
    end

    begin
      User.find_by(username: @json[:username]) do |u|
        p = u.passwd
        if p[:hash] == Digest::SHA2.new(512).hexdigest(@json[:password] + p[:salt])
          Session.create(
              user_id: u.id,
              ip: request.ip
          ) do |doc|
            cookies[:session] = doc.id.to_s
          end
        else
          ret = {
              status: 3,
              msg: 'Contraseña incorrecta'
          }
        end
      end
    rescue
      ret = {
          status: 4,
          msg: 'Error al iniciar sesión'
      }
    end
    return ret.to_json
  end

  get '/ingresa' do
    print request.path_info
    unless @session.blank?
      redirect params[:r] || '/'
    end
    @redir = params[:r]
    @title = 'Ingreso'
    slim :ingresa
  end

  post '/signup' do
    params.each do |k, v|
      if k != 'captures' && v.blank?
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

    begin
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
      redirect '/ingresa'
    rescue
      redirect back
    end
  end
end
