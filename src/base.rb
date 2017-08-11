require 'sinatra/base'
require 'sinatra/cookies'
require_relative 'models/user'
require_relative 'models/project'
require_relative 'models/session'
require_relative 'models/payment'

class BaseController < Sinatra::Base
  helpers Sinatra::Cookies

  before do
    begin
      @session = Session.find(cookies[:session])
      @user = User.find(@session.user_id.to_s)
    rescue
      @session = {}
    end
  end
end