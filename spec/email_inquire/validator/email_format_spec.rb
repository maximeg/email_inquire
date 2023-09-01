# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::Validator::EmailFormat do
  describe ".validate" do
    it "returns nil for a valid address" do
      expect(described_class.validate("john.doe@domain.xyz")).to eq(nil)
    end

    it "returns an invalid response for a nil address" do
      expect(described_class.validate(nil)).to be_a(EmailInquire::Response)
        .and be_invalid
    end

    it "returns an invalid response for a blank address" do
      expect(described_class.validate("")).to be_a(EmailInquire::Response)
        .and be_invalid

      expect(described_class.validate("     ")).to be_a(EmailInquire::Response)
        .and be_invalid
    end

    it "returns an invalid response for an address without @" do
      expect(described_class.validate("a")).to be_a(EmailInquire::Response)
        .and be_invalid

      expect(described_class.validate("john.doedomain.com")).to be_a(EmailInquire::Response)
        .and be_invalid
    end

    it "returns an invalid response for an address with only an @" do
      expect(described_class.validate("@")).to be_a(EmailInquire::Response)
        .and be_invalid

      expect(described_class.validate("  @  ")).to be_a(EmailInquire::Response)
        .and be_invalid
    end

    it "returns an invalid response for an address with several @" do
      expect(described_class.validate("john@doe@domain.com")).to be_a(EmailInquire::Response)
        .and be_invalid
    end

    it "returns nil for an address of length 255" do
      address_255 = "a@#{(("a" * 49) + ".") * 5}com"
      expect(address_255.length).to eq(255)

      expect(described_class.validate(address_255)).to eq(nil)
    end

    it "returns an invalid response for an address of length 256" do
      address_256 = "ab@#{(("a" * 49) + ".") * 5}com"
      expect(address_256.length).to eq(256)

      expect(described_class.validate(address_256)).to be_a(EmailInquire::Response)
        .and be_invalid
    end

    context "considering the name part" do
      it "returns an invalid response for address without name part" do
        expect(described_class.validate("@domain.com")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      it "returns nil for a name containing dots" do
        expect(described_class.validate("john.doe@domain.com")).to eq(nil)
        expect(described_class.validate("john.doe.foo@domain.com")).to eq(nil)
      end

      it "returns nil for a name containing a plus" do
        expect(described_class.validate("john.doe+test@domain.com")).to eq(nil)
      end

      it "returns nil for a name containing a dash" do
        expect(described_class.validate("john-doe@domain.com")).to eq(nil)
      end

      it "returns nil for a name containing an underscore" do
        expect(described_class.validate("john_doe@domain.com")).to eq(nil)
      end

      it "returns nil for a name containing a percent" do
        expect(described_class.validate("john.doe%test@domain.com")).to eq(nil)
      end

      it "returns nil for a name starting with a capital letter" do
        expect(described_class.validate("John.doe@domain.com")).to eq(nil)
      end

      it "returns an invalid response for a name starting with a non-alphanumeric character" do
        expect(described_class.validate("+john.doe@domain.com")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      it "returns an invalid response for a name containing non ascii char" do
        expect(described_class.validate("john.dôe@domain.com")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      it "returns an invalid response for a name longer than 64 chars" do
        expect(described_class.validate("#{"a" * 64}@domain.com")).to eq(nil)

        expect(described_class.validate("#{"a" * 65}@domain.com")).to be_a(EmailInquire::Response)
          .and be_invalid
      end
    end

    context "considering the domain part" do
      it "returns an invalid response for address without domain part" do
        expect(described_class.validate("john@")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      it "returns an invalid response for a domain containing non ascii char" do
        expect(described_class.validate("john@dômain.com")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      it "returns an invalid response for no fully qualified domain" do
        expect(described_class.validate("john@domain")).to be_a(EmailInquire::Response)
          .and be_invalid

        expect(described_class.validate("john@my-domain")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      it "returns an invalid response for an IP address as domain" do
        expect(described_class.validate("john@12.23.34.45")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      it "returns an invalid response for the localhost domain" do
        expect(described_class.validate("john@localhost")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      it "returns nil for a domain having one part of 63 chars" do
        expect(described_class.validate("john@sub.#{"a" * 63}.com")).to eq(nil)
      end

      it "returns an invalid response for a domain having one part of 64 chars" do
        expect(described_class.validate("john@sub.#{"a" * 64}.com")).to be_a(EmailInquire::Response)
          .and be_invalid
      end

      context "considering dashes" do
        it "returns nil for a domain with a dash" do
          expect(described_class.validate("john@my-domain.com")).to eq(nil)
        end

        it "returns an invalid response for a domain with successive dashes" do
          expect(described_class.validate("john@my--domain.com")).to be_a(EmailInquire::Response)
            .and be_invalid

          expect(described_class.validate("john@my---domain.com")).to be_a(EmailInquire::Response)
            .and be_invalid
        end

        it "returns an invalid response for a domain ending with a dash" do
          expect(described_class.validate("john@domain-.com")).to be_a(EmailInquire::Response)
            .and be_invalid
        end

        it "returns an invalid response for a domain starting with a dash" do
          expect(described_class.validate("john@-domain.com")).to be_a(EmailInquire::Response)
            .and be_invalid
        end
      end

      context "considering dots" do
        it "returns nil for a domain with a dot" do
          expect(described_class.validate("john@my.domain.com")).to eq(nil)
        end

        it "returns an invalid response for a domain with successive dots" do
          expect(described_class.validate("john@my..domain.com")).to be_a(EmailInquire::Response)
            .and be_invalid

          expect(described_class.validate("john@domain..com")).to be_a(EmailInquire::Response)
            .and be_invalid

          expect(described_class.validate("john@domain...com")).to be_a(EmailInquire::Response)
            .and be_invalid
        end

        it "returns an invalid response for a domain ending with a dot" do
          expect(described_class.validate("john@domain.com.")).to be_a(EmailInquire::Response)
            .and be_invalid
        end

        it "returns an invalid response for a domain starting with a dot" do
          expect(described_class.validate("john@.domain.com")).to be_a(EmailInquire::Response)
            .and be_invalid
        end
      end
    end
  end
end
