# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: UK TLD", type: :feature do
  %w[
    john.doe@domain.ci.uk
    john.doe@domain.xo.uk
    john.doe@domain.zz.uk
    john.doe@domainco.uk
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@domain.co.uk",
        status: :hint,
      })
    end
  end

  # Registration of .uk has now opened
  it "does not propose a hint for `john.doe@domain.uk` as domain.uk may exists" do
    response = EmailInquire.validate("john.doe@domain.uk")
    expect(response.status).to eq(:valid)
  end

  # https://en.wikipedia.org/wiki/.uk
  %w[
    john.doe@domain.uk
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
  ].each do |kase|
    it "does not propose a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:valid)
    end
  end

  {
    "john.doe@aol.uk" => "john.doe@aol.co.uk",
    "john.doe@blueyonder.uk" => "john.doe@blueyonder.co.uk",
    "john.doe@hotmail.uk" => "john.doe@hotmail.co.uk",
    "john.doe@live.uk" => "john.doe@live.co.uk",
    "john.doe@yahoo.uk" => "john.doe@yahoo.co.uk",
  }.each do |kase, hint|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: hint,
        status: :hint,
      })
    end
  end
end
