# frozen_string_literal: true

require "spec_helper"

describe "Case: La Poste typos" do
  %w[
    john.doe@lapost.net
    john.doe@laposte.com
    john.doe@laposte.fr
    john.doe@laposte.ne
    john.doe@laposte.ner
    john.doe@lapostr.net
    john.doe@lapostz.net
    john.doe@lapote.net
    john.doe@lappste.net
  ].each do |kase|
    it "proposes a hint for #{kase}" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:hint)
      expect(response.replacement).to eq("john.doe@laposte.net")
    end
  end
end
