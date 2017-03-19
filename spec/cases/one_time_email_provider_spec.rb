# frozen_string_literal: true
require "spec_helper"

describe "Case: One-time email providers" do
  %w(
    john.doe@yopmail.com
  ).each do |kase|
    it "detects #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:invalid)
    end
  end
end
