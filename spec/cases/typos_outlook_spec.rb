# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Outlook typos", type: :feature do
  %w[
    john.doe@outloo.com
    john.doe@outloock.com
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@outlook.com",
        status: :hint,
      })
    end
  end

  %w[
    john.doe@iutlook.fr
    john.doe@oitlook.fr
    john.doe@oulook.fr
    john.doe@outllook.fr
    john.doe@outlok.fr
    john.doe@outloo.fr
    john.doe@outlook.fe
    john.doe@outlook.ft
    john.doe@outlouk.fr
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@outlook.fr",
        status: :hint,
      })
    end
  end
end
