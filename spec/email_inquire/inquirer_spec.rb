# frozen_string_literal: true
require "spec_helper"

describe EmailInquire::Inquirer do
  describe "#email" do
    it "returns the provided email" do
      subject = described_class.new("john.doe@example.com")
      expect(subject.email).to eq("john.doe@example.com")
    end
  end

  describe "#validate" do
    it "returns a EmailInquire::Response" do
      subject = described_class.new("john.doe@example.com")
      expect(subject.validate).to be_a(EmailInquire::Response)
    end

    context "with a valid email" do
      let(:email) { "john.doe@example.com" }

      it "returns an according EmailInquire::Response" do
        subject = described_class.new(email)
        expect(subject.validate).to have_attributes({
          email: email,
          valid?: true,
          hint?: false,
          invalid?: false,
          replacement: nil,
        })
      end
    end

    context "with an email with a mistake" do
      let(:email) { "john.doe@gnail.com" }

      it "returns an according EmailInquire::Response" do
        subject = described_class.new(email)
        expect(subject.validate).to have_attributes({
          email: email,
          valid?: false,
          hint?: true,
          invalid?: false,
          replacement: "john.doe@gmail.com",
        })
      end
    end

    context "with an invalid email" do
      let(:email) { "john.doe@yopmail.com" }

      it "returns an according EmailInquire::Response" do
        subject = described_class.new(email)
        expect(subject.validate).to have_attributes({
          email: email,
          valid?: false,
          hint?: false,
          invalid?: true,
          replacement: nil,
        })
      end
    end
  end
end
