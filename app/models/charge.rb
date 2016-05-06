class Charge
  include ActiveModel::Model
  include Mongoid::Document

  field :description, type: String
  field :amount, type: Integer
  field :currency, type: String
  field :reference_id, type: String
  field :card, type: String
  field :details, type: Hash

  validates :amount, :currency, :card, presence: true
  validates :amount, numericality: true
end
