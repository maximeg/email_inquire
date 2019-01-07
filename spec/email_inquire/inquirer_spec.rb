# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Inquirer do
  describe "VALIDATORS" do
    it "contains only EmailInquire::Validator::Base descendents" do
      expect(described_class::VALIDATORS).to all(satisfy { |k| k < EmailInquire::Validator::Base })
    end
  end

  describe "#email" do
    it "returns the provided email" do
      subject = described_class.new("john.doe@domain.com")
      expect(subject.email).to eq("john.doe@domain.com")
    end
  end

  describe "#validate" do
    subject { described_class.new(email) }

    let(:email) { "john.doe@domain.com" }

    it "returns the first response of its validators" do
      expected_response = EmailInquire::Response.new(email: email).invalid!

      stub_const(
        "EmailInquire::Inquirer::VALIDATORS", [
          double(:validator, validate: nil),
          double(:validator, validate: expected_response),
          double(:validator, validate: EmailInquire::Response.new(email: email).invalid!),
        ]
      )

      expect(subject.validate).to equal(expected_response)
    end

    it "returns a valid response when none of its validators give a response" do
      stub_const(
        "EmailInquire::Inquirer::VALIDATORS", [
          double(:validator, validate: nil),
          double(:validator, validate: nil),
          double(:validator, validate: nil),
        ]
      )

      expect(subject.validate).to be_a(EmailInquire::Response).and have_attributes({
        email: "john.doe@domain.com",
        valid?: true,
        hint?: false,
        invalid?: false,
        replacement: nil,
      })
    end

    context "with a valid email containing upcase chars" do
      let(:email) { "John.Doe@Domain.Com" }

      it "calls its validators with the downcased email" do
        validator = double(:validator)
        expect(validator).to receive(:validate).with("john.doe@domain.com")

        stub_const("EmailInquire::Inquirer::VALIDATORS", [validator])

        subject.validate
      end
    end

    context "with a nil email" do
      let(:email) { nil }

      it "calls its validators with the nil email" do
        validator = double(:validator)
        expect(validator).to receive(:validate).with(nil)

        stub_const("EmailInquire::Inquirer::VALIDATORS", [validator])

        subject.validate
      end
    end
  end
end
