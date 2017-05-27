# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Known invalid domains" do
  %w[
    john.doe@example.com
  ].each do |kase|
    it "detects #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:invalid)
    end
  end
end
