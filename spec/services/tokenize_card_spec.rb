require "rails_helper"

RSpec.describe TokenizeCard do

  describe "#run" do
    context "valid card" do
      it "returns a card token to be stored temporarily" do
        card = Card.new(
          number: "4000000000000002",
          name: "John Doe",
          exp_year: 2.years.from_now.year.to_s,
          exp_month: "10",
          cvc: "123"
        )
        result = TokenizeCard.new(card).run
        expect(result).to respond_to :success?
        expect(result.token).to_not be_nil
        expect(result.token).to eq("NDAwMDAwMDAwMDAwMDAwMg==")
      end

      it "persists card in db" do
        card = Card.new(
          number: "4000000000000002",
          name: "John Doe",
          exp_year: 2.years.from_now.year.to_s,
          exp_month: "10",
          cvc: "123"
        )
        expect { TokenizeCard.new(card).run }.to change { Card.count }.by(1)
      end
    end

    context "invalid card" do
      it "returns error" do
        card = Card.new(
          number: "4000000000000002",
          name: "John Doe",
          exp_year: "2000",
          exp_month: "10",
          cvc: "123"
        )

        service = TokenizeCard.new(card)
        result = service.run
        expect(result).to respond_to :error?
        expect(result.error?).to be true
        expect(result.token).to be_nil
      end
    end
  end
end
