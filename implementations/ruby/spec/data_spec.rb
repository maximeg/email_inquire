# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Data" do # rubocop:disable RSpec/DescribeClass
  def load_data(filename)
    data = File.read("#{__dir__}/../data/#{filename}.txt")
    lines = data.split("\n")
    lines.reject! { |line| line[0] == "#" }

    lines
  end

  def duplicates(items)
    items.group_by(&:itself)
      .reject { |_key, value| value.length == 1 }
      .keys
  end

  %w[
    common_providers
    country_code_tld/br
    country_code_tld/jp
    country_code_tld/uk
    known_invalid_domains
    one_time_providers
    unique_domain_providers
  ].each do |filename|
    describe "File #{filename}.txt" do
      it "does not contain duplicates" do
        expect(duplicates(load_data(filename))).to eq([])
      end
    end
  end
end
