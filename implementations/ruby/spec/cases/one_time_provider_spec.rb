# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: One-time email providers", type: :feature do
  %w[
    john.doe@0-mail.com
    john.doe@disposemail.com
    john.doe@mailinator.com
    john.doe@yopmail.com
    john.doe@yopmail.fr
  ].each do |kase|
    it "detects `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:invalid)
    end
  end
end
