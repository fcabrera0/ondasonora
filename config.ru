require_relative 'src/index'
require_relative 'src/session'
require_relative 'src/dash'
require_relative 'src/project'
require_relative 'src/payment'
require 'mongoid'

Mongoid.load!('src/models/mongoid.yml', :development)

use PaymentController
use ProjectController
use DashController
use SessionController
run IndexController