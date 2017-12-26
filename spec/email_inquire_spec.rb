# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire do
  describe ".custom_invalid_domains" do
    context "when untouched" do
      it "returns a set" do
        expect(described_class.custom_invalid_domains).to be_a(Set)
      end
    end
  end

  describe ".custom_invalid_domains=" do
    it "accepts nil" do
      described_class.custom_invalid_domains = nil

      expect(described_class.custom_invalid_domains).to eq(Set.new)
    end

    it "accepts an Array" do
      described_class.custom_invalid_domains = %w[domain1.com domain2.com]

      expect(described_class.custom_invalid_domains).to eq(Set.new(%w[domain1.com domain2.com]))
    end

    it "accepts a Set" do
      described_class.custom_invalid_domains = Set.new(%w[domain1.com domain2.com])

      expect(described_class.custom_invalid_domains).to eq(Set.new(%w[domain1.com domain2.com]))
    end

    it "raises for unsupported types" do
      expect {
        described_class.custom_invalid_domains = "domain1.com"
      }.to raise_error(ArgumentError, "Unsupported type in `custom_invalid_domains=`")

      expect(described_class.custom_invalid_domains).to eq(Set.new)
    end
  end
end
