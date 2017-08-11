require 'mongoid'

class Payment
  include Mongoid::Document
  store_in collection: 'payment', database: 'ondasonora'
  field :user_id, type: BSON::ObjectId
  field :project_id, type: BSON::ObjectId
  field :items, type: Array
  field :amount, type: Integer
  field :date, type: DateTime, default: -> { DateTime.now }
  field :status, type: Integer, default: 0
  field :transaction, type: Hash
end