require_relative 'base'
require 'khipu'
require 'paypal-sdk-rest'

PayPal::SDK::REST.set_config(
    :mode => 'sandbox',
    :client_id => 'AaEdV45aJKGRKa8031wUK5utd-p7LEgzCP3W7XGcg1MQPEYdPBSFScYT-yROH12bV3EwG67nXnLUHcYS',
    :client_secret => 'ECEr2iOvx_9htoBG-_4co8tNJ0AoN11IK_sAUiSssApbmz1UjremQHK7efKUYyMrS3iGMFUQATdI79wI'
)

module Khipu
  @@khipu_conf = {
      :id => '119057',
      :secret => '66c795a1c246857cc33f8a1a3b6058a2c58ce7eb'
  }

  def self.get (amount, detail, project, user)
    client = Khipu.create_khipu_api(@@khipu_conf[:id], @@khipu_conf[:secret])

    data = {
        subject: "Donación al proyecto #{project.name}",
        body: -> {
          text = ''
          detail.each do |e|
            text += "#{e[:name]}: #{e[:quantity]} x $#{e[:floor]}\n"
          end
          text
        }.call,
        amount: amount.to_s,
        email: user.email
    }

    c = client.create_payment_url(data)

    {
        :url => c['url'],
        :id => c['id']
    }
  end
end

module PayPal
  def self.get (amount, detail, project, user, request)
    data = {
        :intent => "sale",
        :payer => {
            :payment_method => "paypal"
        },
        :redirect_urls => {
            :return_url => "#{request.base_url}/dash",
            :cancel_url => "#{request.base_url}/dash"
        },
        :transactions => [{
                              :item_list=> {
                                  :items => detail.map { |e| {
                                                 :name => e[:name],
                                                 :sku => "item",
                                                 :price => e[:floor],
                                                 :currency => "USD",
                                                 :quantity => e[:quantity]
                                             } }
                              },
                              :amount => {
                                  :currency => "USD",
                                  :total => amount
                              },
                              :description => "Donación al proyecto #{project[:name]}"
                          }]
    }
    payment = PayPal::SDK::REST::Payment.new(data)

    payment.create

    pay = payment.links.find { |e| e if e.method == 'REDIRECT' }

    {
        :url => pay.href,
        :id => payment.id
    }
  end
end

class PaymentController < BaseController
  get '/donar/proyecto/:id' do
    if @session.blank?
      redirect "/ingresa?r=/donar/proyecto/#{params[:id]}"
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
    @json = JSON.parse(request.body.read, :symbolize_names => true)

    return {
        status: 1,
        msg: 'Sesión expirada'
    }.to_json if @session.blank?

    @project = Project.find(params[:id])

    return {
        status: 2,
        msg: 'Método de pago inválido'
    }.to_json if not ['khipu', 'paypal'].include? (@json[:method])

    return {
        status: 3,
        msg: 'No puedes donar a tu propio proyecto'
    }.to_json if @project.by.to_s == @user.id.to_s

    return {
        status: 4,
        msg: 'No estás autorizado para donar'
    }.to_json if @user.status < 0

    payment = -> {
      if @json[:method] == 'khipu'
        Khipu.get(@json[:amount], @json[:items], @project, @user)
      else
        PayPal.get(@json[:amount], @json[:items], @project, @user, request)
      end
    }.call

    Payment.create(
               user_id: @user.id,
               project_id: @project.id,
               items: @json[:items],
               amount: @json[:amount],
               transaction: {
                   id: payment[:id],
                   url: payment[:url],
                   method: @json[:method]
               }
    )

    content_type :json
    {
        status: 0,
        data: payment
    }.to_json
  end
end