# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Helper do
  describe "#first_value" do
    let(:my_block) { ->(a) { a * 2 } }

    it "returns the first non nil evaluated value" do
      my_block = ->(a) { a * 10 if a >= 1 }
      expect(described_class.first_value([0], &my_block)).to eq(nil)
      expect(described_class.first_value([0, 1], &my_block)).to eq(10)
      expect(described_class.first_value([0, 1, 2], &my_block)).to eq(10)
    end

    it "does not call the block more than necessary" do
      calls = 0

      expect {
        described_class.first_value([0, 1, 2, 3]) do |val|
          calls += 1

          val <= 1
        end
      }.to change { calls }.from(0).to(1)
    end
  end
end
