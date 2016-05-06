class Card
  include ActiveModel::Model
  include ActiveModel::Validations
  include Mongoid::Document

  field :name, type: String
  field :bin, type: String
  field :last_4, type: String
  field :exp_date, type: DateTime
  field :brand, type: String
  field :address, type: Hash
  field :token, type: String

  attr_accessor :number, :exp_year, :exp_month, :cvc

  validates :number, :name, :exp_month, :exp_year, :cvc, presence: true
  validates :number, credit_card_number: true
  validate :validate_expiration_date

  before_create :set_persistable_attrs

  private

  def validate_expiration_date
    expiration_date = build_expiration_date(exp_year, exp_month)
    self.errors.add(:exp_date, "is expired") unless Time.zone.now <= expiration_date
  end

  def set_persistable_attrs
    self.bin = number.to_s[0..5]
    self.last_4 = number.to_s[-4..-1]
    self.exp_date = build_expiration_date(exp_year, exp_month)
  end

  def build_expiration_date(year, month)
    Time.new(year.to_i, month.to_i).end_of_month
  end
end
