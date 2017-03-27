# frozen_string_literal: true
require "damerau-levenshtein"
require "set"

module EmailInquire

  class Inquirer

    class << self

      private

      def load_data(filename)
        data = File.read("#{__dir__}/../../data/#{filename}.txt")
        lines = data.split("\n")
        lines.reject! { |line| line[0] == "#" }

        lines.to_set
      end

    end

    def initialize(email)
      @email = email.downcase

      parse_email
    end

    attr_reader :domain, :email, :name

    def validate
      validate_typos

      response
    end

    private

    def parse_email
      @name, @domain = email.split("@")
    end

    def response
      @response ||= Response.new.tap do |response|
        response.email = email
      end
    end

    VALIDATORS = [
      :validate_common_domains,
      :validate_one_time_providers,
      :validate_common_domain_mistakes,
      :validate_cc_tld,
      :validate_common_tld_mistakes,
      :validate_domains_with_unique_tld,
    ].freeze

    def validate_typos
      VALIDATORS.each do |validator|
        send(validator)
        break if response.valid? || response.invalid?
      end

      # default
      response.valid! unless response.status?
    end

    COMMON_DOMAIN_MISTAKES = {
      /google(?!mail)/ => "gmail.com",
      /windows.*\.com/ => "live.com",
    }.freeze

    def validate_common_domain_mistakes
      COMMON_DOMAIN_MISTAKES.each do |mistake, reference|
        break if domain == reference # valid!

        if mistake =~ domain
          response.hint!(domain: reference)
          break
        end
      end
    end

    COMMON_DOMAINS = load_data("common_providers").freeze

    def validate_common_domains
      return response.valid! if COMMON_DOMAINS.include?(domain)

      COMMON_DOMAINS.each do |reference|
        distance = ::DamerauLevenshtein.distance(domain, reference, 2, 3)
        if distance <= 1
          response.hint!(domain: reference)
          break
        end
      end
    end

    COMMON_TLD_MISTAKES = {
      ".cojp" => ".co.jp",
      ".couk" => ".co.uk",
      ".com.com" => ".com",
    }.freeze

    def validate_common_tld_mistakes
      COMMON_TLD_MISTAKES.each do |mistake, reference|
        break if !mistake.end_with?(reference) && domain.end_with?(reference)

        if domain.end_with?(mistake)
          response.hint!(domain: domain.gsub(/#{mistake}\z/, reference))
          break
        end
      end
    end

    VALID_JP_TLD = load_data("jp_tld").freeze
    VALID_UK_TLD = load_data("uk_tld").freeze
    VALID_CC_TLDs = [
      [".jp", ".co.jp", VALID_JP_TLD],
      [".uk", ".co.uk", VALID_UK_TLD],
    ].freeze

    def validate_cc_tld
      VALID_CC_TLDs.each do |tld, sld, valid_tld|
        next unless domain.end_with?(tld)

        next if valid_tld.any? do |reference|
          domain.end_with?(reference)
        end

        new_domain = domain.dup
        tld_without_dot = tld[1..-1]
        new_domain.gsub!(/\.[a-z]{2}\.#{tld_without_dot}\z/, sld)
        new_domain.gsub!(/(?<!\.)co\.#{tld_without_dot}\z/, sld)
        new_domain.gsub!(/(?<!\.co)\.#{tld_without_dot}\z/, sld)
        response.hint!(domain: new_domain) if new_domain != domain
      end
    end

    UNIQUE_TLD_DOMAINS = load_data("unique_domain_providers").freeze

    def validate_domains_with_unique_tld
      base, tld = domain.split(".")

      UNIQUE_TLD_DOMAINS.each do |reference|
        reference_base, reference_tld = reference.split(".")

        if base == reference_base && tld != reference_tld
          response.hint!(domain: reference)
          break
        end
      end
    end

    ONE_TIME_EMAIL_PROVIDERS = load_data("one_time_email_providers").freeze

    def validate_one_time_providers
      response.invalid! if ONE_TIME_EMAIL_PROVIDERS.include?(domain)
    end

  end

end
