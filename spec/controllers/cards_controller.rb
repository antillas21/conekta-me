require "rails_helper"

RSpec.describe CardsController, type: :controller do
  describe "#create" do
    context "valid card" do
      let(:valid_params) do
        {
          card: {
            name: "John Doe",
            number: "5555555555554444",
            exp_year: 2.years.from_now.year.to_s,
            exp_month: "10",
            cvc: "123"
          }
        }
      end

      it "returns a 200 status" do
        post :create, valid_params, format: :json
        expect(response.status).to eq(200)
      end

      it "returns json with token value" do
        post :create, valid_params, format: :json
        json = JSON.parse(response.body)
        expect(json["token"]).to_not be_nil
        binding.pry
      end
    end

    context "invalid card" do
      let(:invalid_params) do
        {
          card: {
            name: "John Doe",
            number: "57855555554444",
            exp_year: 2.years.ago.year.to_s,
            exp_month: "10",
            cvc: "456"
          }
        }
      end

      it "returns 402 status" do
        post :create, invalid_params, format: :json
        expect(response.status).to eq(402)
      end

      it "returns error json response" do
        post :create, invalid_params, format: :json
        json = JSON.parse(response.body)["data"]
        expect(json["error"]).to be true
        expect(json.keys).to include("errors")
      end
    end
  end
end
