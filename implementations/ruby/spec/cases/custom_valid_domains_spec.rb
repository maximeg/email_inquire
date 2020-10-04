# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Custom valid domains", type: :feature do
  context "when EmailInquire.custom_valid_domains is not set" do
    it "works for hinted domains" do
      response = EmailInquire.validate("john.doe@sfr.com")
      expect(response.status).to eq(:hint)
    end

    it "works for invalid domains" do
      response = EmailInquire.validate("john.doe@example.com")
      expect(response.status).to eq(:invalid)
    end
  end

  context "when EmailInquire.custom_valid_domains is set" do
    before do
      EmailInquire.custom_valid_domains << "sfr.com"
      EmailInquire.custom_valid_domains << "example.com"
    end

    it "detects the would be hinted domains set" do
      response = EmailInquire.validate("john.doe@sfr.com")
      expect(response.status).to eq(:valid)
    end

    it "detects the would be invalid domains set" do
      response = EmailInquire.validate("john.doe@example.com")
      expect(response.status).to eq(:valid)
    end
  end
end
