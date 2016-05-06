require "rails_helper"

RSpec.describe ChargeCard do
  describe "#run" do
    context "valid card token" do
      let(:card) do
        Card.new(
          number: "4000000000000002",
          name: "John Doe",
          exp_year: 2.years.from_now.year.to_s,
          exp_month: "10",
          cvc: "123"
        )
      end

      it "creates a new Charge object" do
        tokenizer_result = TokenizeCard.new(card).run
        token = tokenizer_result.token

        charge_params = {
          amount: 900,
          currency: "MXN",
          card: token
        }

        expect { ChargeCard.new(charge_params).run }.to change { Charge.count }.by(1)
      end

      it "returns Charge object in response" do
        tokenizer_result = TokenizeCard.new(card).run
        token = tokenizer_result.token

        charge_params = {
          amount: 900,
          currency: "MXN",
          card: token
        }

        result = ChargeCard.new(charge_params).run
        expect(result.charge).to be_a Charge
      end
    end

    context "invalid card token" do
      it "returns card invalid in errors" do
        charge_params = {
          amount: 900,
          currency: "MXN",
          card: "invalidToken",
        }

        result = ChargeCard.new(charge_params).run
        expect(result.errors.values).to include("card is invalid")
      end
    end

    context "invalid Charge params" do
      it "returns Charge object errors" do
        charge_params = {
          amount: 900
        }
        result = ChargeCard.new(charge_params).run
        expect(result.errors.keys).to include(:currency)
        expect(result.errors.keys).to include(:card)
      end
    end
  end
end
