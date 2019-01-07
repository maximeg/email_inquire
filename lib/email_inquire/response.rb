# frozen_string_literal: true

module EmailInquire
  class Response

    attr_reader :email
    attr_accessor :replacement, :status

    def initialize(email:)
      @email = email
    end

    def hint!(domain:)
      self.status = :hint

      old_name, _old_domain = email.split("@")
      self.replacement = "#{old_name}@#{domain}"

      self
    end

    def hint?
      status.equal?(:hint)
    end

    def invalid!
      self.status = :invalid

      self
    end

    def invalid?
      status.equal?(:invalid)
    end

    def status?
      !status.nil?
    end

    def valid!
      self.status = :valid

      self
    end

    def valid?
      status.equal?(:valid)
    end

  end
end
