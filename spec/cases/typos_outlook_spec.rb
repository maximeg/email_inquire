# frozen_string_literal: true

require "spec_helper"

describe "Case: Outlook typos" do
  %w[
    john.doe@outloo.com
    john.doe@outloock.com
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@outlook.com")
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
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@outlook.fr")
    end
  end
end
