class ChargesController < ApiBaseController
  respond_to :json

  def create
    result = ChargeCard.new(charge_params).run
    if result.success?
      render json: result.charge.to_json, status: 200
    else
      render json: { errors: result.errors.to_json }, status: 402
    end
  end

  def show
    charge = Charge.find(params[:id])
    if charge
      render json: charge, status: 200
    else
      render json: { error: "Not found" }, status: 404
    end
  end

  private

  def charge_params
    params.require(:charge).permit(
      :amount,
      :currency,
      :card,
      :description,
      :reference_id,
    )
  end
end
