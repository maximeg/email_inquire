# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::CommonProviderMistake do
  describe ".validate" do
    it "returns nil for an unrelated address" do
      expect(described_class.validate("john@domain.xyz")).to eq(nil)
    end

    it "returns nil for a listed address" do
      expect(described_class.validate("john@gmail.com")).to eq(nil)
    end

    it "returns an hint response for an address with one char subtitution typo" do
      expect(described_class.validate("john@gnail.com")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@gmail.com")
    end

    it "returns an hint response for an address with one char adding typo" do
      expect(described_class.validate("john@gmmail.com")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@gmail.com")
    end

    it "returns an hint response for an address with one char removing typo" do
      expect(described_class.validate("john@gail.com")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@gmail.com")
    end

    it "returns an hint response for an address with one typo involving the position of the dot" do
      expect(described_class.validate("john@gmai.lcom")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@gmail.com")
    end

    it "returns nil for an address with two char substitution typos" do
      expect(described_class.validate("john@jnail.com")).to eq(nil)
    end

    it "returns nil for an address with two char adding typos" do
      expect(described_class.validate("john@gmmmail.com")).to eq(nil)
    end

    it "returns nil for an address with two char removing typos" do
      expect(described_class.validate("john@gml.com")).to eq(nil)
    end
  end
end
