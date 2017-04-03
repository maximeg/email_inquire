# frozen_string_literal: true

require "spec_helper"

describe "Case: Free typos" do
  %w[
    john.doe@free.com
    john.doe@free.fe
    john.doe@frer.fr
    john.doe@gree.fr
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@free.fr")
    end
  end
end
