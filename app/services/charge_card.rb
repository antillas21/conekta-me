class ChargeCard
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :amount, :currency, :card

  def run
    charge = Charge.new(amount: amount, currency: currency, card: card)
    if charge.valid? && is_valid?(card)
      charge.save
      return Response.new(
        success: true,
        charge: charge
      )
    else
      return Response.new(
        errors: charge.errors.to_h.merge(card: "card is invalid"),
        error: true
      )
    end
  end

  private

  def is_valid?(card)
    # eventually here is where the Redis lookup logic can be performed
    return false if Card.find_by(token: card).nil?
    true
  end

  class Response
    def initialize(data = {})
      @data = data
    end

    def charge
      data.fetch(:charge, nil)
    end

    def errors
      data.fetch(:errors, [])
    end

    def success?
      data.fetch(:success, false)
    end

    def error?
      data.fetch(:error, false)
    end

    private

    attr_reader :data
  end
end
