# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::CommonlyMistakenTld do
  describe ".validate" do
    it "returns nil for an unrelated address" do
      expect(described_class.validate("john@domain.xyz")).to eq(nil)
    end

    it "returns nil for an address matching a corrected tld" do
      expect(described_class.validate("john@domain.com")).to eq(nil)

      expect(described_class.validate("john@domain.com.br")).to eq(nil)

      expect(described_class.validate("john@domain.co.jp")).to eq(nil)

      expect(described_class.validate("john@domain.co.jp")).to eq(nil)
    end

    it "returns an hint response for a matching tld" do
      expect(described_class.validate("john@domain.com.com")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@domain.com")

      expect(described_class.validate("john@domain.combr")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@domain.com.br")

      expect(described_class.validate("john@domain.couk")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@domain.co.uk")

      expect(described_class.validate("john@domain.cojp")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@domain.co.jp")
    end
  end
end
