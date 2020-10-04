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
      other_response = EmailInquire::Response.new(email: email).invalid!

      stub_const(
        "#{described_class}::VALIDATORS", [
          class_double("EmailInquire::Validator::Base", validate: nil),
          class_double("EmailInquire::Validator::Base", validate: expected_response),
          class_double("EmailInquire::Validator::Base", validate: other_response),
        ]
      )

      expect(subject.validate).to equal(expected_response)
    end

    it "returns a valid response when none of its validators give a response" do
      stub_const(
        "#{described_class}::VALIDATORS", [
          class_double("EmailInquire::Validator::Base", validate: nil),
          class_double("EmailInquire::Validator::Base", validate: nil),
        ]
      )

      expect(subject.validate).to be_a(EmailInquire::Response).and have_attributes({
        email: "john.doe@domain.com",
        status: :valid,
        replacement: nil,
      })
    end

    end
    context "with a valid email containing upcase chars" do
      let(:email) { "John.Doe@Domain.Com" }

      it "calls its validators with the downcased email" do
        validator = class_double("EmailInquire::Validator::Base", validate: nil)
        stub_const("#{described_class}::VALIDATORS", [validator])

        subject.validate

        expect(validator).to have_received(:validate).with("john.doe@domain.com")
      end

    context "with a nil email" do
      let(:email) { nil }

      it "calls its validators with the nil email" do
        validator = class_double("EmailInquire::Validator::Base", validate: nil)
        stub_const("#{described_class}::VALIDATORS", [validator])

        subject.validate

        expect(validator).to have_received(:validate).with(nil)
      end
    end
  end
end
