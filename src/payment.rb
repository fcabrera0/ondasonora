require_relative 'base'

class PaymentController < BaseController
  get '/donar/:id' do
    if @session.blank?
      redirect '/ingresa'
    end

    if @project.by.to_s == @user.id.to_s
      redirect "/dash/#{params[:id]}"
    end

    
  end
end