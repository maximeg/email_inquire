# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Custom invalid domains", type: :feature do
  context "when EmailInquire.custom_invalid_domains is not set" do
    it "works" do
      response = EmailInquire.validate("john.doe@my-domain.com")
      expect(response.status).to eq(:valid)
    end
  end

  context "when EmailInquire.custom_invalid_domains is set" do
    before do
      EmailInquire.custom_invalid_domains << "my-domain.com"
    end

    it "detects the domain set" do
      response = EmailInquire.validate("john.doe@my-domain.com")
      expect(response.status).to eq(:invalid)
    end
  end
end
