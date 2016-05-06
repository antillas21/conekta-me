class TokenizeCard
  def initialize(card = Card.new)
    @card = card
  end

  def run
    if card.valid?
      token = generate_token(card)
      card.token = token
      card.save
      return Response.new(
        success: true,
        token: token
      )
    else
      return Response.new(
        errors: card.errors.messages,
        error: true
      )
    end
  end

  private

  attr_reader :card

  def generate_token(card)
    Base64.urlsafe_encode64(card.number)
  end

  class Response
    def initialize(data = {})
      @data = data
    end

    def token
      data.fetch(:token, nil)
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
