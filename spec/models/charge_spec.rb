require "rails_helper"

RSpec.describe Charge, type: :model do
  it { is_expected.to validate_presence_of :amount }
  it { is_expected.to validate_presence_of :currency }
  it { is_expected.to validate_presence_of :card }
  it { is_expected.to validate_numericality_of :amount }
end
