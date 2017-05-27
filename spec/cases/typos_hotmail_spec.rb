# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Hotmail typos" do
  %w[
    john.doe@hitmail.com
    john.doe@homail.com
    john.doe@homtail.com
    john.doe@hormail.com
    john.doe@hotail.com
    john.doe@hotamil.com
    john.doe@hotmaik.com
    john.doe@hotmail.col
    john.doe@hotmail.con
    john.doe@hotmail.cop
    john.doe@hotmal.com
    john.doe@hotmaol.com
    john.doe@hotmaul.com
    john.doe@hotmil.com
    john.doe@jotmail.com
    john.doe@otmail.com
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@hotmail.com")
    end
  end

  %w[
    john.doe@botmail.fr
    john.doe@gotmail.fr
    john.doe@hitmail.fr
    john.doe@homail.fr
    john.doe@homtail.fr
    john.doe@hormail.fr
    john.doe@hotail.fr
    john.doe@hotamail.fr
    john.doe@hotamil.fr
    john.doe@hotlail.fr
    john.doe@hotmaail.fr
    john.doe@hotmai.fr
    john.doe@hotmaik.fr
    john.doe@hotmail.dr
    john.doe@hotmail.fe
    john.doe@hotmail.ff
    john.doe@hotmail.frr
    john.doe@hotmail.ft
    john.doe@hotmail.gr
    john.doe@hotmaill.fr
    john.doe@hotmaim.fr
    john.doe@hotmaio.fr
    john.doe@hotmal.fr
    john.doe@hotmaol.fr
    john.doe@hotmaul.fr
    john.doe@hotmil.fr
    john.doe@hotmsil.fr
    john.doe@hotmzil.fr
    john.doe@htmail.fr
    john.doe@jotmail.fr
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@hotmail.fr")
    end
  end

  # domains which are known burners
  %w[
    john.doe@hotmai.com
  ].each do |kase|
    it "sets #{kase} as invalid" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:invalid)
    end
  end
end
