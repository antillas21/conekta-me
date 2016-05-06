require "rails_helper"

RSpec.describe ChargesController do
  describe "#create" do
    before(:each) do
      card = Card.new(
          number: "4000000000000002",
          name: "John Doe",
          exp_year: 2.years.from_now.year.to_s,
          exp_month: "10",
          cvc: "123"
        )
      tokenizer_result = TokenizeCard.new(card).run
      @token = tokenizer_result.token
    end

    let(:valid_params) do
      {
        charge: {
          card: @token,
          amount: 900,
          currency: "MXN"
        }
      }
    end

    context "with valid params" do
      it "creates new Charge object" do
        expect { post :create, valid_params, format: :json}.to change { Charge.count }.by(1)
      end

      it "returns 200 status" do
        post :create, valid_params, format: :json
        expect(response.status).to eq(200)
      end

      it "returns Charge object in json format" do
        post :create, valid_params, format: :json
        json = JSON.parse(response.body)
        expect(json["amount"]).to eq(valid_params[:charge][:amount])
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          charge: {
            amount: 900,
            card: "invalid_token"
          }
        }
      end

      it "returns 402 status" do
        post :create, invalid_params, format: :json
        expect(response.status).to eq(402)
      end

      it "returns an error json response" do
        post :create, invalid_params, format: :json
        json = JSON.parse(response.body)
        expect(json.keys).to include("errors")
      end
    end
  end

  describe "#show" do
    it "returns a Charge object if exists" do
      charge = Charge.create(
        amount: 900,
        currency: "MXN",
        card: "card_token_foo"
      )

      get :show, { id: charge.id }, format: :json
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json["card"]).to eq(charge.card)
    end

    it "returns 404 status if Charge objects doesn't exist" do
      get :show, { id: SecureRandom.uuid }, format: :json
      expect(response.status).to eq(404)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Not found")
    end
  end
end
