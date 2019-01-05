# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Response do
  subject { described_class.new(email: "john.doe@domain.com") }

  describe "#hint!" do
    before do
      subject.hint!(domain: "newdomain.com")
    end

    it "sets the status to hint" do
      expect(subject.status).to eq(:hint)

      expect(subject.hint?).to eq(true)
      expect(subject.invalid?).to eq(false)
      expect(subject.valid?).to eq(false)
    end

    it "sets the replacement address" do
      expect(subject.replacement).to eq("john.doe@newdomain.com")
    end
  end

  describe "#invalid!" do
    before do
      subject.invalid!
    end

    it "sets the status to invalid" do
      expect(subject.status).to eq(:invalid)

      expect(subject.hint?).to eq(false)
      expect(subject.invalid?).to eq(true)
      expect(subject.valid?).to eq(false)
    end

    it "does not set a replacement address" do
      expect(subject.replacement).to eq(nil)
    end
  end

  describe "#status?" do
    context "when status is not set" do
      it "returns false" do
        expect(subject.status?).to eq(false)
      end
    end

    context "when status is set" do
      before do
        subject.status = :foo
      end

      it "returns true" do
        expect(subject.status?).to eq(true)
      end
    end
  end

  describe "#valid!" do
    before do
      subject.valid!
    end

    it "sets the status to valid" do
      expect(subject.status).to eq(:valid)

      expect(subject.hint?).to eq(false)
      expect(subject.invalid?).to eq(false)
      expect(subject.valid?).to eq(true)
    end

    it "does not set a replacement address" do
      expect(subject.replacement).to eq(nil)
    end
  end
end
