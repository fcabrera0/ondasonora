require_relative 'src/index'
require_relative 'src/session'
require_relative 'src/dash'
require_relative 'src/project'
require 'mongoid'

Mongoid.load!('src/models/mongoid.yml', :development)

set :port, 3000

use ProjectController
use DashController
use SessionController
run IndexController