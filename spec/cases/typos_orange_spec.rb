# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Orange typos", type: :feature do
  %w[
    john.doe@irange.fr
    john.doe@oange.fr
    john.doe@oeange.fr
    john.doe@orage.fr
    john.doe@oranfe.fr
    john.doe@orange.fe
    john.doe@orange.ff
    john.doe@orange.ft
    john.doe@orange.gr
    john.doe@orangr.fr
    john.doe@ornge.fr
    john.doe@prange.fr
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@orange.fr",
        status: :hint,
      })
    end
  end
end
