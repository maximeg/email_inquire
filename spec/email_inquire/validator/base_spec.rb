# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::Base do
  describe ".validate" do
    it "raises" do
      expect {
        described_class.validate("john@domain.xyz")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#domain" do
    subject { described_class.send(:new, "john@domain.xyz") }

    it "returns a the domain part" do
      expect(subject.domain).to eq("domain.xyz")
    end

    it "is memoized" do
      domain = subject.send(:domain)
      expect(subject.send(:domain)).to equal(domain)
    end
  end

  describe "#email" do
    subject { described_class.send(:new, "john@domain.xyz") }

    it "returns a the email" do
      expect(subject.email).to eq("john@domain.xyz")
    end

    it "is memoized" do
      email = subject.send(:email)
      expect(subject.send(:email)).to equal(email)
    end
  end

  describe "#name" do
    subject { described_class.send(:new, "john@domain.xyz") }

    it "returns a the name part" do
      expect(subject.name).to eq("john")
    end

    it "is memoized" do
      name = subject.send(:name)
      expect(subject.send(:name)).to equal(name)
    end
  end

  describe "#response" do
    subject { described_class.send(:new, "john@domain.xyz") }

    it "returns a EmailInquire::Response" do
      expect(subject.send(:response)).to be_a(EmailInquire::Response)
        .and have_attributes(
          email: "john@domain.xyz",
          status: nil
        )
    end

    it "is memoized" do
      response = subject.send(:response)
      expect(subject.send(:response)).to equal(response)
    end
  end
end
