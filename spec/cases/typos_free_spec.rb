# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Free typos", type: :feature do
  %w[
    john.doe@free.com
    john.doe@free.fe
    john.doe@frer.fr
    john.doe@gree.fr
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@free.fr",
        status: :hint,
      })
    end
  end
end
