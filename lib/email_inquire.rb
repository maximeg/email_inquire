# frozen_string_literal: true

require "email_inquire/version"
require "email_inquire/inquirer"

module EmailInquire

  def self.validate(email)
    inquirer = Inquirer.new(email)
    inquirer.validate
  end

  def self.custom_invalid_domains=(domains)
    @custom_invalid_domains =
      case domains
      when Set, nil
        domains
      when Array
        domains.to_set
      else
        raise ArgumentError, "Unsupported type in `custom_invalid_domains=`"
      end
  end

  def self.custom_invalid_domains
    @custom_invalid_domains ||= Set.new
  end

  def self.custom_valid_domains=(domains)
    @custom_valid_domains =
      case domains
      when Set
        domains
      when Array
        domains.to_set
      when nil
        nil
      else
        raise ArgumentError, "Unsupported type in `custom_valid_domains=`"
      end
  end

  def self.custom_valid_domains
    @custom_valid_domains ||= Set.new
  end

end
