# frozen_string_literal: true

require "email_inquire/validator/base"

module EmailInquire
  module Validator
    class EmailFormat < Base

      DOMAIN_REGEXP = /
        \A
        (?:
          (?=
            [a-z0-9-]{1,63}
            \.
          )
          [a-z0-9]+
          (?:
            -
            [a-z0-9]+
          )*
          \.
        ){1,8}
        [a-z]{2,63}
        \z
      /x.freeze

      NAME_ALLOWED_CHARS = /[a-z0-9._%+-]/.freeze

      NAME_REGEXP = /
        \A
        [a-z0-9]
        [#{NAME_ALLOWED_CHARS}]{0,63}
        \z
      /x.freeze

      # Relevant literature:
      # http://emailregex.com/email-validation-summary/
      # http://www.regular-expressions.info/email.html

      def validate
        response.invalid! if !email || email.length > 255 || !name_valid? || !domain_valid?
      end

      private

      def domain_valid?
        domain =~ DOMAIN_REGEXP
      end

      def name_valid?
        name =~ NAME_REGEXP
      end

    end
  end
end
