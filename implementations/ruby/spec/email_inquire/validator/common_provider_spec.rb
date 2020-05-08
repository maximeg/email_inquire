# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::CommonProvider do
  describe "DOMAINS" do
    it "contains only domains" do
      expect(described_class::DOMAINS).to all(match(DOMAIN_REGEXP_SPEC))
    end
  end

  describe ".validate" do
    it "returns nil for an unrelated address" do
      expect(described_class.validate("john@domain.xyz")).to eq(nil)
    end

    it "returns a valid response for a listed address" do
      expect(described_class.validate("john@gmail.com")).to be_a(EmailInquire::Response)
        .and be_valid
    end

    it "returns nil for an address with typo" do
      expect(described_class.validate("john@gnail.com")).to eq(nil)
    end
  end
end
