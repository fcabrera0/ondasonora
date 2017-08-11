require 'mongoid'

class User
  include Mongoid::Document
  store_in collection: 'user', database: 'ondasonora'
  field :username, type: String
  field :email, type: String
  field :rut, type: String
  field :joined, type: DateTime, default: -> { DateTime.now }
  field :status, type: Integer, default: 0
  field :passwd, type: Hash
  field :profile, type: Hash
end