# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::OneTimeProvider do
  describe "DOMAINS" do
    it "contains only domains" do
      expect(described_class::DOMAINS).to all(match(DOMAIN_REGEXP_SPEC))
    end
  end

  describe ".validate" do
    it "returns nil for an unrelated address" do
      expect(described_class.validate("john@domain.xyz")).to eq(nil)
    end

    it "returns an hint response for a listed domain" do
      expect(described_class.validate("john@yopmail.com")).to be_a(EmailInquire::Response)
        .and be_invalid
    end
  end
end
