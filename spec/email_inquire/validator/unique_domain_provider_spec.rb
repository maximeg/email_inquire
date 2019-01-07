# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::UniqueDomainProvider do
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

    it "returns an hint response for a matching address" do
      expect(described_class.validate("john@gmail.fr")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@gmail.com")
    end
  end
end
