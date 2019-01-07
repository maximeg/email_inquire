# frozen_string_literal: true

require "email_inquire/helper"
require "email_inquire/response"
require "email_inquire/validator/common_provider"
require "email_inquire/validator/common_provider_mistake"
require "email_inquire/validator/commonly_mistaken_domain"
require "email_inquire/validator/commonly_mistaken_tld"
require "email_inquire/validator/country_code_tld"
require "email_inquire/validator/custom_invalid_domain"
require "email_inquire/validator/custom_valid_domain"
require "email_inquire/validator/email_format"
require "email_inquire/validator/known_invalid_domain"
require "email_inquire/validator/one_time_provider"
require "email_inquire/validator/unique_domain_provider"

module EmailInquire
  class Inquirer

    def initialize(email)
      @email = email&.downcase
    end

    attr_reader :email

    VALIDATORS = [
      # Format first
      EmailInquire::Validator::EmailFormat,

      # Custom overrides
      EmailInquire::Validator::CustomValidDomain,
      EmailInquire::Validator::CustomInvalidDomain,

      # Always valid domains
      EmailInquire::Validator::CommonProvider,

      # Invalid domains
      EmailInquire::Validator::KnownInvalidDomain,
      EmailInquire::Validator::OneTimeProvider,

      # Hints
      EmailInquire::Validator::CommonProviderMistake,
      EmailInquire::Validator::CommonlyMistakenDomain,
      EmailInquire::Validator::CommonlyMistakenTld,
      EmailInquire::Validator::CountryCodeTld,
      EmailInquire::Validator::UniqueDomainProvider,
    ].freeze

    def validate
      response = Helper.first_value(VALIDATORS) { |validator| validator.validate(email) }

      response || Response.new(email: email).valid!
    end

  end
end
