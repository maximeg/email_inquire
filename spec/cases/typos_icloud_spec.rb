# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: iCloud typos", type: :feature do
  # nice to have: john.doe@icould.com
  %w[
    john.doe@cloud.com
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@icloud.com",
        status: :hint,
      })
    end
  end
end
