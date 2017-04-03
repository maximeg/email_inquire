# frozen_string_literal: true

require "spec_helper"

describe "Case: Wanadoo typos" do
  %w(
    john.doe@wanado.fr
    john.doe@wanadoi.fr
    john.doe@wanadoo.com
    john.doe@wanadoo.dr
    john.doe@wanadoo.fe
    john.doe@wanadoo.ff
    john.doe@wanadop.fr
    john.doe@wanasoo.fr
    john.doe@wandoo.fr
  ).each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@wanadoo.fr")
    end
  end
end
