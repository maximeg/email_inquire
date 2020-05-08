# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::CustomValidDomain do
  describe ".validate" do
    before do
      EmailInquire.custom_valid_domains << "my-domain.com"
    end

    it "returns nil for an unrelated address" do
      expect(described_class.validate("john@domain.xyz")).to eq(nil)
    end

    it "returns a valid response for a listed domain" do
      expect(described_class.validate("john@my-domain.com")).to be_a(EmailInquire::Response)
        .and be_valid
    end
  end
end
