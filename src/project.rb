require_relative 'base'
require 'json'

class ProjectController < BaseController
  get '/proyecto/:id' do
    @project = Project.find(params[:id])
    unless @project && @project.status > 0
      redirect '/error'
    end
    @by = User.find(@project.by.to_s)
    @plans = @project.plans || []
    @title = @project.name
    slim :proyecto
  end

  get '/dash/proyecto/:id' do
    @project = Project.find(params[:id])
    unless @project
      redirect '/dash'
    end
    if @session.blank? || @project.by.to_s != @user.id.to_s
      redirect '/ingresa'
    end
    @plans = @project.plans || []
    @payments = Payment.where(project_id: @project.id, state: 1)
    @title = @project.name
    slim :editar_proyecto
  end

  post '/dash/proyecto/:id' do
    @project = Project.find(params[:id])
    unless @project
      redirect '/error'
    end
    if @session.blank? || @project.by.to_s != @user.id.to_s
      redirect '/ingresa'
    end

    @project.descr = params[:descr]
    @project.save
    redirect back
  end

  post '/plans/:id' do
    @project = Project.find(params[:id])
    if @project.by.to_s == @user.id.to_s
      @project.plans = JSON.parse(params[:plans])
      @project.save
    end
  end

  get '/financia' do
    if @session.blank?
      redirect '/ingresa'
    end
    if @user.status < 1
      redirect '/dash'
    end
    @title = 'Empezar un proyecto'
    slim :financia
  end

  post '/financia' do
    if @session.blank?
      redirect '/ingresa'
    end

    if @user.status < 1
      redirect '/dash'
    end

    begin
      deadline = Date.parse(params[:deadline])
      unless Date.today - deadline > 30
        redirect back
      end

      Project.create(
          name: params[:name],
          cat: params[:cat].to_i,
          flex: params[:flex] == 'true' ? true : false,
          descr: params[:descr],
          by: @user.id,
          goal: params[:goal].to_i,
          deadline: deadline
      )
      redirect '/dash'
    rescue
      redirect back
    end
  end
end