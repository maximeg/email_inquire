# frozen_string_literal: true
require "spec_helper"

describe "Case: UK TLD" do
  %w(
    john.doe@domain.ci.uk
    john.doe@domain.uk
    john.doe@domain.xo.uk
    john.doe@domain.zz.uk
    john.doe@domainco.uk
  ).each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@domain.co.uk")
    end
  end

  # https://en.wikipedia.org/wiki/.uk
  %w(
    john.doe@domain.ac.uk
    john.doe@domain.co.uk
    john.doe@domain.gov.uk
    john.doe@domain.judiciary.uk
    john.doe@domain.ltd.uk
    john.doe@domain.me.uk
    john.doe@domain.mod.uk
    john.doe@domain.net.uk
    john.doe@domain.nhs.uk
    john.doe@domain.nic.uk
    john.doe@domain.org.uk
    john.doe@domain.parliament.uk
    john.doe@domain.plc.uk
    john.doe@domain.police.uk
    john.doe@domain.sch.uk
  ).each do |kase|
    it "does not propose a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:valid)
    end
  end
end
