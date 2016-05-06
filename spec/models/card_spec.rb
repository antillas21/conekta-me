require "rails_helper"

RSpec.describe Card, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :number }
  it { is_expected.to validate_presence_of :exp_year }
  it { is_expected.to validate_presence_of :exp_month }
  it { is_expected.to validate_presence_of :cvc }

  it "validates card number against Luhn" do
    valid_card = Card.new(
      name: "John Doe",
      number: "5555555555554444",
      exp_year: 2.years.from_now.year.to_s,
      exp_month: "10",
      cvc: "123"
    )

    invalid_card = Card.new(
      name: "John Doe",
      number: "57855555554444",
      exp_year: 2.years.from_now.year.to_s,
      exp_month: "10",
      cvc: "456"
    )

    expect(valid_card).to be_valid
    expect(invalid_card).to_not be_valid
  end

  it "validates expiration date" do
    invalid_card = Card.new(
      name: "John Doe",
      number: "5555555555554444",
      exp_year: 1.year.ago.year.to_s,
      exp_month: "10",
      cvc: "123"
    )
    expect(invalid_card).to_not be_valid
  end
end
