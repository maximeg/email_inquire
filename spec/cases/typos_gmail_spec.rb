# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Case: Gmail typos", type: :feature do
  %w[
    john.doe@gmail.com
    john.doe@googlemail.com
  ].each do |kase|
    it "considers valid `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:valid)
    end
  end

  %w[
    john.doe@email.com
    john.doe@fmail.com
    john.doe@g.mail.com
    john.doe@gail.com
    john.doe@gamail.com
    john.doe@gamil.com
    john.doe@gemail.com
    john.doe@ggmail.com
    john.doe@glail.com
    john.doe@gmai.com
    john.doe@gmaik.com
    john.doe@gmail.cim
    john.doe@gmail.clm
    john.doe@gmail.cm
    john.doe@gmail.co
    john.doe@gmail.col
    john.doe@gmail.com.com
    john.doe@gmail.comcomm
    john.doe@gmail.comm
    john.doe@gmail.con
    john.doe@gmail.cop
    john.doe@gmail.cpm
    john.doe@gmail.fr
    john.doe@gmail.om
    john.doe@gmail.vom
    john.doe@gmail.xom
    john.doe@gmaim.com
    john.doe@gmaio.com
    john.doe@gmaol.com
    john.doe@gmaul.com
    john.doe@gmil.com
    john.doe@gmsil.com
    john.doe@gmzil.com
    john.doe@gnail.com
    john.doe@google.fr
    john.doe@hmail.com
  ].each do |kase|
    it "proposes a hint for `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response).to have_attributes({
        replacement: "john.doe@gmail.com",
        status: :hint,
      })
    end
  end

  # domains which are known burners
  %w[
    john.doe@gmal.com
    john.doe@gmial.com
  ].each do |kase|
    it "considers invalid `#{kase}`" do
      response = EmailInquire.validate(kase)
      expect(response.status).to eq(:invalid)
    end
  end
end
