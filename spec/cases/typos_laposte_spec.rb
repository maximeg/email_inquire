# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: La Poste typos", type: :feature do
  %w[
    john.doe@lapost.net
    john.doe@laposte.com
    john.doe@laposte.fr
    john.doe@laposte.ne
    john.doe@laposte.ner
    john.doe@lapostr.net
    john.doe@lapostz.net
    john.doe@lapote.net
    john.doe@lappste.net
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@laposte.net",
        status: :hint,
      })
    end
  end
end
