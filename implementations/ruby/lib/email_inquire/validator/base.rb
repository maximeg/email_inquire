# frozen_string_literal: true

require "set"
require "email_inquire/response"

module EmailInquire
  module Validator
    class Base

      class << self

        def validate(email)
          new(email).validate
        end

        private :new

        private

        def load_data(filename)
          data = File.read("#{__dir__}/../../../data/#{filename}.txt")
          lines = data.split("\n")
          lines.reject! { |line| line[0] == "#" }

          lines.to_set
        end

      end

      def initialize(email)
        @email = email
        @name, @domain = email&.split("@", 2)
      end

      attr_reader :domain, :email, :name

      def validate
        raise NotImplementedError
      end

      private

      def response
        @response ||= Response.new(email: email)
      end

    end
  end
end
