# frozen_string_literal: true

require "spec_helper"

describe "Case: Not overly helpful" do
  %w(
    john.doe@domain.ca
  ).each do |kase|
    it "does not propose a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:valid)
    end
  end
end
