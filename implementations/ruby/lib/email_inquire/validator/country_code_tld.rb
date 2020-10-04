# frozen_string_literal: true

require "email_inquire/helper"
require "email_inquire/validator/base"
require "email_inquire/validator/common_provider"

module EmailInquire
  module Validator
    class CountryCodeTld < Base

      COUNTRY_CODE_TLDS = [
        # TLD, generic com, all generic, registration with TLD only is possible
        ["jp", "co", load_data("country_code_tld/jp").freeze, true].freeze,
        ["uk", "co", load_data("country_code_tld/uk").freeze, true].freeze,
        ["br", "com", load_data("country_code_tld/br").freeze, true].freeze,
      ].freeze

      def initialize(email)
        super(email)

        *@rest, @sld, @tld = domain.split(".")
      end

      def validate
        Helper.first_value(
          COUNTRY_CODE_TLDS
        ) do |cctld, generic_com, all_generics, registration_with_cctld|
          validate_cctld(cctld, generic_com, all_generics, registration_with_cctld)
        end
      end

      private

      attr_reader :rest, :sld, :tld

      def hint_for_approx_cctld(cctld, all_generics)
        matching_generic = all_generics.find { |generic| tld.eql?("#{generic}#{cctld}") }
        return unless matching_generic

        replacement = [*rest, sld, matching_generic, cctld].join(".")
        response.hint!(domain: replacement)
      end

      def hint_for_common_provider(cctld, generic_com)
        provider_domain = [
          sld,
          generic_com,
          cctld,
        ].join(".")

        return unless CommonProvider::DOMAINS.include?(provider_domain)

        response.hint!(domain: provider_domain)
      end

      def hint_for_generic_com(cctld, generic_com)
        replacement = [
          *rest,
          (sld if sld.length > 2),
          generic_com,
          cctld,
        ].compact.join(".")

        response.hint!(domain: replacement)
      end

      def hint_for_generic_at_end_of_sld(cctld, all_generics)
        generic_at_end_of_sld = all_generics.find { |generic| sld.end_with?(generic) }
        return unless generic_at_end_of_sld

        replacement = [
          *rest,
          sld.sub(/#{generic_at_end_of_sld}\z/, ""),
          generic_at_end_of_sld,
          cctld,
        ].join(".")

        response.hint!(domain: replacement)
      end

      def validate_cctld(cctld, generic_com, all_generics, registration_with_cctld)
        return hint_for_approx_cctld(cctld, all_generics) unless tld.eql?(cctld)

        if all_generics.include?(sld)
          return response.invalid! if rest.empty?

          return
        end

        (
          hint_for_generic_at_end_of_sld(cctld, all_generics) ||
          hint_for_common_provider(cctld, generic_com)
        ).tap do |hint|
          return hint if hint
        end

        hint_for_generic_com(cctld, generic_com) if sld.length <= 2 || !registration_with_cctld
      end

    end
  end
end
