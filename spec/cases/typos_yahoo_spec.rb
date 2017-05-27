# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Yahoo typos" do
  %w[
    john.doe@yahoo.co.uk
    john.doe@yahoo.com
    john.doe@yahoo.fr
    john.doe@ymail.com
  ].each do |kase|
    it "considers valid #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:valid)
    end
  end

  %w[
    john.doe@yahooo.com
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@yahoo.com")
    end
  end

  %w[
    john.doe@tahoo.fr
    john.doe@uahoo.fr
    john.doe@yaboo.fr
    john.doe@yaho.fr
    john.doe@yahoi.fr
    john.doe@yahol.fr
    john.doe@yahoo.fe
    john.doe@yahoo.ff
    john.doe@yahoo.ft
    john.doe@yahoo.gr
    john.doe@yahooo.fr
    john.doe@yahou.fr
    john.doe@yajoo.fr
    john.doe@yaoo.fr
    john.doe@yhaoo.fr
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@yahoo.fr")
    end
  end

  %w[
    john.doe@yahoo.uk
    john.doe@yhoo.co.uk
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@yahoo.co.uk")
    end
  end
end
