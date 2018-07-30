# frozen_string_literal: true

require "email_inquire/version"
require "email_inquire/email_validator"
require "email_inquire/inquirer"
require "email_inquire/response"

module EmailInquire

  def self.validate(email)
    inquirer = Inquirer.new(email)
    inquirer.validate
  end

  def self.custom_invalid_domains=(domains)
    @@custom_invalid_domains =
      case domains
      when Set
        domains
      when Array
        domains.to_set
      when nil
        Set.new
      else
        raise ArgumentError, "Unsupported type in `custom_invalid_domains=`"
      end
  end

  def self.custom_invalid_domains
    @@custom_invalid_domains ||= Set.new

    @@custom_invalid_domains
  end

  def self.custom_valid_domains=(domains)
    @@custom_valid_domains =
      case domains
      when Set
        domains
      when Array
        domains.to_set
      when nil
        Set.new
      else
        raise ArgumentError, "Unsupported type in `custom_valid_domains=`"
      end
  end

  def self.custom_valid_domains
    @@custom_valid_domains ||= Set.new

    @@custom_valid_domains
  end

end
