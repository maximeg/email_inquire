# frozen_string_literal: true
module EmailInquire

  class Response

    attr_accessor :email, :replacement, :status

    def hint!(domain: nil)
      self.status = :hint

      old_name, _old_domain = email.split("@")
      self.replacement = "#{old_name}@#{domain}" if domain
    end

    def hint?
      status == :hint
    end

    def invalid!
      self.status = :invalid
    end

    def invalid?
      status == :invalid
    end

    def status?
      !status.nil?
    end

    def valid!
      self.status = :valid
    end

    def valid?
      status == :valid
    end

  end

end
