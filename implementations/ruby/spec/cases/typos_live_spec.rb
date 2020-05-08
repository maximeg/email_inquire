# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Live typos", type: :feature do
  %w[
    john.doe@liv.com
    john.doe@live.co
    john.doe@livr.com
    john.doe@windowslive.com
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@live.com",
        status: :hint,
      })
    end
  end

  %w[
    john.doe@liv.fr
    john.doe@live.fe
    john.doe@live.ff
    john.doe@live.ft
    john.doe@livr.fr
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@live.fr",
        status: :hint,
      })
    end
  end
end
