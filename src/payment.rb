require_relative 'base'
require 'khipu'
require 'paypal-rest-sdk'

include PayPal::SDK::REST

PayPal::SDK::REST.set_config(
    :mode => 'sandbox',
    :client_id => 'AaEdV45aJKGRKa8031wUK5utd-p7LEgzCP3W7XGcg1MQPEYdPBSFScYT-yROH12bV3EwG67nXnLUHcYS',
    :client_secret => 'ECEr2iOvx_9htoBG-_4co8tNJ0AoN11IK_sAUiSssApbmz1UjremQHK7efKUYyMrS3iGMFUQATdI79wI'
)

class Khipu
  @@khipu_conf = {
      :id => '119057',
      :secret => '66c795a1c246857cc33f8a1a3b6058a2c58ce7eb'
  }

  def self.get (amount, detail, project, user)
    client = Khipu.create_khipu_api(@@khipu_conf[:id], @@khipu_conf[:secret])
    data = {
        subject: "Donación al proyecto #{project[:name]}",
        body: detail.map { |e| "#{e[:name]}: #{e[:quantity]} x $#{e[:floor]}" }.join("\n"),
        amount: amount.to_s,
        email: user[:email]
    }

    c = client.create_payment_url(data)

    {
        :url => c['url'],
        :id => c['id']
    }
  end
end

class PayPal
  def self.get (amount, detail, project, user)
    
  end
end

class PaymentController < BaseController
  get '/donar/proyecto/:id' do
    if @session.blank?
      redirect '/ingresa'
    end

    @project = Project.find(params[:id])
    unless @project
      redirect '/error'
    end

    if @project.by.to_s == @user.id.to_s
      redirect "/dash/#{params[:id]}"
    end
    @by = User.find(@project.by.to_s)
    @plans = @project.plans || []
    @payments = Payment.where(project_id: @project.id, state: 1)
    @title = @project.name

    slim :donar
  end

  post '/pay/:id' do
    return {
        status: 1,
        msg: 'Sesión expirada'
    }.to_json if @session.blank?

    @project = Project.find(params[:id])

    return {
        status: 2,
        msg: 'Método de pago inválido'
    }.to_json if not ['khipu', 'paypal'].include? (params[:method])

    return {
        status: 3,
        msg: 'No puedes donar a tu propio proyecto'
    }.to_json if @project.by.to_s == @user.id.to_s

    return {
        status: 4,
        msg: 'No estás autorizado para donar'
    }.to_json if @user.status < 0

    payment = -> {
      if params[:method] == 'khipu'
        Khipu.get(params[:amount], params[:items], @project.map, @user.map)
      else
        PayPal.get(params[:amount], params[:items], @project.map, @user.map)
      end
    }


    {
        status: 0,
        data: payment
    }.to_json
  end
end