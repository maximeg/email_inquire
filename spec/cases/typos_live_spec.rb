# frozen_string_literal: true
require "spec_helper"

describe "Case: Live typos" do
  %w(
    john.doe@liv.com
    john.doe@live.co
    john.doe@livr.com
    john.doe@windowslive.com
  ).each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@live.com")
    end
  end

  %w(
    john.doe@liv.fr
    john.doe@live.fe
    john.doe@live.ff
    john.doe@live.ft
    john.doe@livr.fr
  ).each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@live.fr")
    end
  end
end
