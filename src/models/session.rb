require 'mongoid'

class Session
  include Mongoid::Document
  store_in collection: 'session', database: 'ondasonora'
  field :user_id, type: BSON::ObjectId
  field :date, type: DateTime, default: -> { DateTime.now }
  field :ip, type: String
end