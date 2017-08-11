require 'mongoid'

class Project
  include Mongoid::Document
  store_in collection: 'project', database: 'ondasonora'
  field :by, type: String
  field :cat, type: Integer
  field :name, type: String
  field :flex, type: Boolean
  field :descr, type: String
  field :creation, type: DateTime, default: -> { DateTime.now }
  field :goal, type: Integer
  field :deadline, type: Date
  field :media, type: Array
  field :plans, type: Array
  field :current, type: Integer, default: 0
  field :private, type: Boolean, default: true
  field :status, type: Integer, default: -1
end