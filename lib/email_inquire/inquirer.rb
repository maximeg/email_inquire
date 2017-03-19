# frozen_string_literal: true
require "damerau-levenshtein"

module EmailInquire

  class Inquirer

    def initialize(email)
      @email = email.downcase
      response.email = email

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
      @response ||= Response.new
    end

    def validate_typos
      [
        :validate_common_domains,
        :validate_one_time_providers,
        :validate_common_domain_mistakes,
        :validate_uk_tld,
        :validate_common_tld_mistakes,
        :validate_domains_with_unique_tld,
      ].each do |validator|
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

    COMMON_DOMAINS = %w(
      aim.com
      aliceadsl.fr
      aol.co.uk
      aol.com
      att.net
      bbox.fr
      bellsouth.net
      blueyonder.co.uk
      btinternet.com
      charter.net
      cox.net
      free.fr
      gmail.com
      gmx.fr
      googlemail.com
      hotmail.co.uk
      hotmail.com
      hotmail.fr
      icloud.com
      laposte.net
      live.co.uk
      live.com
      live.fr
      me.com
      msn.com
      neuf.fr
      ntlworld.com
      numericable.fr
      orange.fr
      outlook.com
      outlook.fr
      rocketmail.com
      sbcglobal.net
      sfr.fr
      sky.com
      talktalk.net
      verizon.net
      virginmedia.com
      wanadoo.fr
      yahoo.co.uk
      yahoo.com
      yahoo.fr
      ymail.com
    ).freeze

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

    VALID_UK_TLD = %w(
      .ac.uk
      .co.uk
      .gov.uk
      .judiciary.uk
      .ltd.uk
      .me.uk
      .mod.uk
      .net.uk
      .nhs.uk
      .nic.uk
      .org.uk
      .parliament.uk
      .plc.uk
      .police.uk
      .sch.uk
    ).freeze

    def validate_uk_tld
      return unless domain.end_with?(".uk")

      return if VALID_UK_TLD.any? do |reference|
        domain.end_with?(reference)
      end

      new_domain = domain.dup
      new_domain.gsub!(/(?<!\.)co\.uk\z/, ".co.uk")
      new_domain.gsub!(/\.c[^o]\.uk\z/, ".co.uk")
      new_domain.gsub!(/\.[^c]o\.uk\z/, ".co.uk")
      new_domain.gsub!(/(?<!co)\.uk\z/, ".co.uk")

      response.hint!(domain: new_domain) if new_domain != domain
    end

    UNIQUE_TLD_DOMAINS = %w(
      free.fr
      gmail.com
      laposte.net
      sfr.fr
      wanadoo.fr
    ).freeze

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

    # https://github.com/wesbos/burner-email-providers
    ONE_TIME_EMAIL_PROVIDERS = %w(
      yopmail.com
    ).freeze

    def validate_one_time_providers
      response.invalid! if ONE_TIME_EMAIL_PROVIDERS.include?(domain)
    end

  end

end
