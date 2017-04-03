# frozen_string_literal: true

require "spec_helper"

describe "Case: iCloud typos" do
  # nice to have: john.doe@icould.com
  %w(
    john.doe@cloud.com
  ).each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@icloud.com")
    end
  end
end
