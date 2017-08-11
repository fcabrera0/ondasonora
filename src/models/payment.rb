require 'mongoid'

class Payment
  include Mongoid::Document
  store_in collection: 'payment', database: 'ondasonora'
  field :user_id, type: BSON::ObjectId
  field :project_id, type: BSON::ObjectId
  field :amount, type: Integer
  field :date, type: DateTime
  field :state, type: Integer
  field :transaction, type: Hash
end