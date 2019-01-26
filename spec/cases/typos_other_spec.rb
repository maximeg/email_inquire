# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Other typos", type: :feature do
  {
    "john.doe@domain.com.com" => "john.doe@domain.com",
  }.each do |kase, hint|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: hint,
        status: :hint,
      })
    end
  end

  %w[
    john.doe@aliceafsl.fr
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@aliceadsl.fr",
        status: :hint,
      })
    end
  end

  %w[
    john.doe@al.com
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@aol.com",
        status: :hint,
      })
    end
  end

  %w[
    john.doe@ail.com
    john.doe@ain.com
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@aim.com",
        status: :hint,
      })
    end
  end

  %w[
    john.doe@nulericable.fr
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@numericable.fr",
        status: :hint,
      })
    end
  end

  %w[
    john.doe@sf.fr
    john.doe@sfe.fr
    john.doe@sfr.com
    john.doe@sfr.fe
    john.doe@sft.fr
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@sfr.fr",
        status: :hint,
      })
    end
  end
end
