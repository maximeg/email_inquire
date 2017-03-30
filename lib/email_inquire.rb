# frozen_string_literal: true

require "email_inquire/version"
require "email_inquire/inquirer"
require "email_inquire/response"

module EmailInquire

  def self.validate(email)
    inquirer = Inquirer.new(email)
    inquirer.validate
  end

end
