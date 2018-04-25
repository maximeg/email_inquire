# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Other typos" do
  {
    "john.doe@domain.com.com" => "john.doe@domain.com",
  }.each do |kase, hint|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq(hint)
    end
  end

  %w[
    john.doe@aliceafsl.fr
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@aliceadsl.fr")
    end
  end

  %w[
    john.doe@al.com
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@aol.com")
    end
  end

  %w[
    john.doe@ail.com
    john.doe@ain.com
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@aim.com")
    end
  end

  %w[
    john.doe@nulericable.fr
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@numericable.fr")
    end
  end

  %w[
    john.doe@sf.fr
    john.doe@sfe.fr
    john.doe@sfr.fe
    john.doe@sft.fr
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@sfr.fr")
    end
  end
end
