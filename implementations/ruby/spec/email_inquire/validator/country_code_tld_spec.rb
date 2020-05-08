# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::CountryCodeTld do
  describe "COUNTRY_CODE_TLDS" do
    part_regexp = /\A[a-z][a-z0-9]*\z/

    it "is valid" do
      described_class::COUNTRY_CODE_TLDS
        .each do |cctld, generic_com, all_generics, registration_with_cctld|
          expect(cctld).to match(part_regexp)
          expect(generic_com).to match(part_regexp)
          expect(all_generics).to all(match(part_regexp))
          expect(registration_with_cctld).to eq(true).or(eq(false))
        end
    end
  end

  describe ".validate" do
    it "returns nil for an unrelated address" do
      expect(described_class.validate("john@domain.xyz")).to eq(nil)
    end

    context "with a .comi.xx ccTLD" do
      shared_examples "common .comi.xx" do
        it "returns nil for an address with a listed generic domain" do
          expect(described_class.validate("john@domain.comi.xx")).to eq(nil)

          expect(described_class.validate("john@domain.foo.xx")).to eq(nil)

          expect(described_class.validate("john@domain.bar.xx")).to eq(nil)
        end

        it "returns an invalid response for an address with only a listed generic domain" do
          expect(described_class.validate("john@comi.xx")).to be_a(EmailInquire::Response)
            .and be_invalid

          expect(described_class.validate("john@foo.xx")).to be_a(EmailInquire::Response)
            .and be_invalid

          expect(described_class.validate("john@bar.xx")).to be_a(EmailInquire::Response)
            .and be_invalid
        end

        it "returns a hint for an address with an unknown generic domain of 1 to 2 chars" do
          expect(described_class.validate("john@domain.a.xx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@domain.comi.xx")

          expect(described_class.validate("john@domain.aa.xx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@domain.comi.xx")
        end

        it "returns a hint for an address with the com generic domain and tld without the dot" do
          expect(described_class.validate("john@domain.comixx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@domain.comi.xx")

          expect(described_class.validate("john@sub.domain.comixx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@sub.domain.comi.xx")
        end

        it "returns a hint for an address with a listed generic domain and tld without the dot" do
          expect(described_class.validate("john@domain.fooxx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@domain.foo.xx")

          expect(described_class.validate("john@sub.domain.fooxx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@sub.domain.foo.xx")
        end

        it "returns nil for an address with nearly a tld without the dot" do
          # Special case
          expect(described_class.validate("john@domai.ncoxx")).to eq(nil)

          expect(described_class.validate("john@sub.domai.ncoxx")).to eq(nil)
        end

        it "returns a hint for an address with the com domain at the end of the domain" do
          expect(described_class.validate("john@domaincomi.xx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@domain.comi.xx")

          expect(described_class.validate("john@sub.domaincomi.xx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@sub.domain.comi.xx")
        end

        it "returns a hint for an address with a listed generic domain at the end of the domain" do
          expect(described_class.validate("john@domainfoo.xx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@domain.foo.xx")

          expect(described_class.validate("john@sub.domainfoo.xx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@sub.domain.foo.xx")
        end

        it "returns a hint for an address matching a common provider" do
          expect(described_class.validate("john@provider.xx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@provider.comi.xx")

          expect(described_class.validate("john@sub.provider.xx")).to be_a(EmailInquire::Response)
            .and be_hint
            .and have_attributes(replacement: "john@provider.comi.xx")
        end

        it "returns nil for an address being a common provider" do
          expect(described_class.validate("john@provider.comi.xx")).to eq(nil)

          expect(described_class.validate("john@sub.provider.comi.xx")).to eq(nil)
        end
      end

      context "when allowing registration with .xx" do
        before do
          stub_const(
            "#{described_class}::COUNTRY_CODE_TLDS",
            [
              ["xx", "comi", %w[comi foo bar].freeze, true].freeze,
            ].freeze
          )

          stub_const(
            "EmailInquire::Validator::CommonProvider::DOMAINS",
            [
              "provider.comi.xx",
              "otherprovider.comim",
            ].freeze
          )
        end

        context "with an address with a listed tld" do
          include_examples "common .comi.xx"

          it "returns nil for an address without the generic domain" do
            expect(described_class.validate("john@domain.xx")).to eq(nil)
          end

          it "returns nil for an address with an unknown generic domain of more than 2 chars" do
            expect(described_class.validate("john@domain.aaa.xx")).to eq(nil)

            expect(described_class.validate("john@domain.unknown.xx")).to eq(nil)
          end
        end
      end

      context "when not allowing registration with .xx" do
        before do
          stub_const(
            "#{described_class}::COUNTRY_CODE_TLDS",
            [
              ["xx", "comi", %w[comi foo bar].freeze, false].freeze,
            ].freeze
          )

          stub_const(
            "EmailInquire::Validator::CommonProvider::DOMAINS",
            [
              "provider.comi.xx",
            ].freeze
          )
        end

        context "with an address with a listed tld" do
          include_examples "common .comi.xx"

          it "returns a hint for an address without the generic domain" do
            expect(described_class.validate("john@domain.xx")).to be_a(EmailInquire::Response)
              .and be_hint
              .and have_attributes(replacement: "john@domain.comi.xx")
          end

          it "returns a hint for an address with an unknown generic domain of more than 2 chars" do
            expect(described_class.validate("john@domain.aaa.xx")).to be_a(EmailInquire::Response)
              .and be_hint
              .and have_attributes(replacement: "john@domain.aaa.comi.xx")

            expect(described_class.validate("john@domain.unknown.xx"))
              .to be_a(EmailInquire::Response)
              .and be_hint
              .and have_attributes(replacement: "john@domain.unknown.comi.xx")
          end
        end
      end
    end
  end
end
