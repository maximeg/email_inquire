# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Wanadoo typos", type: :feature do
  %w[
    john.doe@wanado.fr
    john.doe@wanadoi.fr
    john.doe@wanadoo.com
    john.doe@wanadoo.dr
    john.doe@wanadoo.fe
    john.doe@wanadoo.ff
    john.doe@wanadop.fr
    john.doe@wanasoo.fr
    john.doe@wandoo.fr
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@wanadoo.fr",
        status: :hint,
      })
    end
  end
end
