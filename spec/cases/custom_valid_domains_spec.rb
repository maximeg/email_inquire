# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Custom valid domains" do
  context "when EmailInquire.custom_valid_domains is not set" do
    it "works" do
      response = EmailInquire.validate("john.doe@mail.com")
      expect(response.status).to eq(:hint)
    end
  end

  context "when EmailInquire.custom_valid_domains is set" do
    before do
      EmailInquire.custom_valid_domains << "mail.com"
    end

    it "detects the domain set" do
      response = EmailInquire.validate("john.doe@mail.com")
      expect(response.status).to eq(:valid)
    end
  end
end
