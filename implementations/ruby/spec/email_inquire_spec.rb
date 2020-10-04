# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire do
  describe "VERSION" do
    it "exists and has the right format" do
      expect(described_class::VERSION).to be_a(String).and match(/\A\d+\.\d+\.\d+\z/)
    end
  end

  describe ".custom_invalid_domains" do
    context "when untouched" do
      it "returns a set" do
        expect(described_class.custom_invalid_domains).to be_a(Set)
      end

      it "returns the same set" do
        expect(described_class.custom_invalid_domains)
          .to equal(described_class.custom_invalid_domains)
      end
    end

    context "when touched" do
      let(:set) { Set.new(%w[domain1.com domain2.com]) }

      before do
        described_class.custom_invalid_domains = set
      end

      it "returns a set" do
        expect(described_class.custom_invalid_domains).to be_a(Set)
      end

      it "returns the same set" do
        expect(described_class.custom_invalid_domains).to equal(set)
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
        .and not_change { described_class.custom_invalid_domains }.from(Set.new)
    end
  end

  describe ".custom_valid_domains" do
    context "when untouched" do
      it "returns a set" do
        expect(described_class.custom_valid_domains).to be_a(Set)
      end

      it "returns the same set" do
        expect(described_class.custom_valid_domains).to equal(described_class.custom_valid_domains)
      end
    end

    context "when touched" do
      let(:set) { Set.new(%w[domain1.com domain2.com]) }

      before do
        described_class.custom_valid_domains = set
      end

      it "returns a set" do
        expect(described_class.custom_valid_domains).to be_a(Set)
      end

      it "returns the same set" do
        expect(described_class.custom_valid_domains).to equal(set)
      end
    end
  end

  describe ".custom_valid_domains=" do
    it "accepts nil" do
      described_class.custom_valid_domains = nil

      expect(described_class.custom_valid_domains).to eq(Set.new)
    end

    it "accepts an Array" do
      described_class.custom_valid_domains = %w[domain1.com domain2.com]

      expect(described_class.custom_valid_domains).to eq(Set.new(%w[domain1.com domain2.com]))
    end

    it "accepts a Set" do
      described_class.custom_valid_domains = Set.new(%w[domain1.com domain2.com])

      expect(described_class.custom_valid_domains).to eq(Set.new(%w[domain1.com domain2.com]))
    end

    it "raises for unsupported types" do
      expect {
        described_class.custom_valid_domains = "domain1.com"
      }.to raise_error(ArgumentError, "Unsupported type in `custom_valid_domains=`")
        .and not_change { described_class.custom_valid_domains }.from(Set.new)
    end
  end

  describe ".validate" do
    it "works" do
      response = described_class.validate("john.doe@domain.com")

      expect(response).to be_a(EmailInquire::Response).and be_valid
    end
  end
end
