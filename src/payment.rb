require_relative 'base'

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
end