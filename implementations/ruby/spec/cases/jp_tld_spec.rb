# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: JP TLD", type: :feature do
  %w[
    john.doe@domain.ci.jp
    john.doe@domain.xo.jp
    john.doe@domain.zz.jp
    john.doe@domainco.jp
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@domain.co.jp",
        status: :hint,
      })
    end
  end

  # Registration of .jp has now opened
  it "does not propose a hint for `john.doe@domain.jp` as domain.jp may exists" do
    response = EmailInquire.validate("john.doe@domain.jp")
    expect(response.status).to eq(:valid)
  end

  # https://en.wikipedia.org/wiki/.jp
  %w[
    john.doe@domain.ac.jp
    john.doe@domain.ad.jp
    john.doe@domain.co.jp
    john.doe@domain.ed.jp
    john.doe@domain.go.jp
    john.doe@domain.gr.jp
    john.doe@domain.lg.jp
    john.doe@domain.ne.jp
    john.doe@domain.or.jp
  ].each do |kase|
    it "does not propose a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:valid)
    end
  end
end
