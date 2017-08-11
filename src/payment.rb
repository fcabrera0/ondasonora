require_relative 'base'

class Khipu
  def self.get (amount, detail)

  end
end

class PayPal
  def self.get (amount, detail)

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
        Khipu.get(params[:amount], params[:items])
      else
        PayPal.get(params[:amount], params[:items])
      end
    }


    {
        status: 0,
        data: payment
    }.to_json
  end
end