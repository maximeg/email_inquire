# frozen_string_literal: true

module EmailInquire
  # Relevant literature:
  # http://emailregex.com/email-validation-summary/
  # http://www.regular-expressions.info/email.html
  class EmailValidator

    def initialize(email)
      @email = email&.downcase
    end

    attr_reader :email

    def valid?
      return false unless email
      return false if email.length > 255

      name, domain = email.split("@", 2)

      name_valid?(name) && domain_valid?(domain)
    end

    private

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

    def domain_valid?(domain)
      return false unless domain =~ DOMAIN_REGEXP

      true
    end

    NAME_REGEXP = /
      \A
      [a-z0-9]
      [a-z0-9._%+-]{0,63}
      \z
    /x.freeze

    def name_valid?(name)
      return false unless name =~ NAME_REGEXP

      true
    end

  end
end
