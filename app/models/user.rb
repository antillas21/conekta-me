class User
  include Mongoid::Document

  field :api_token
  field :email

  before_validation :set_token

  validates :email, :api_token, presence: true, uniqueness: true

  private

  def set_token
    self.api_token = SecureRandom.urlsafe_base64
  end
end
