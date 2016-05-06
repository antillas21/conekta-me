class CardsController < ApiBaseController
  respond_to :json

  def create
    card = Card.new(card_params)
    result = TokenizeCard.new(card).run
    if result.success?
      render json: { token: result.token }, status: 200
    else
      render json: result.to_json, status: 402
    end
  end

  private

  def card_params
    params.require(:card).permit(
      :name,
      :number,
      :cvc,
      :exp_month,
      :exp_year,
      address: [
        :address_line,
        :city,
        :state,
        :zip,
        :country
      ]
    )
  end
end
