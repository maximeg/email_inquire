# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::CommonlyMistakenTld do
  describe ".validate" do
    before do
      stub_const(
        "#{described_class}::MISTAKES",
        {
          ".foobar" => ".foo.bar",
        }.freeze
      )
    end

    it "returns nil for an unrelated address" do
      expect(described_class.validate("john@domain.xyz")).to eq(nil)
    end

    it "returns nil for an address matching a corrected tld" do
      expect(described_class.validate("john@domain.foo")).to eq(nil)

      expect(described_class.validate("john@domain.foo.bar")).to eq(nil)
    end

    it "returns an hint response for a matching tld" do
      expect(described_class.validate("john@domain.foobar")).to be_a(EmailInquire::Response)
        .and be_hint
        .and have_attributes(replacement: "john@domain.foo.bar")
    end
  end
end
