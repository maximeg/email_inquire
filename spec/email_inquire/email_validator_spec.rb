# frozen_string_literal: true

require "spec_helper"

RSpec.describe EmailInquire::EmailValidator do
  describe "#valid?" do
    it "returns true for a valid address" do
      subject = described_class.new("john.doe@domain.com")
      expect(subject.valid?).to eq(true)
    end

    it "returns true for a valid address with upcase chars" do
      subject = described_class.new("John.Doe@Domain.Com")
      expect(subject.valid?).to eq(true)
    end

    it "returns false for a nil address" do
      subject = described_class.new(nil)
      expect(subject.valid?).to eq(false)
    end

    it "returns false for a blank address" do
      subject = described_class.new("")
      expect(subject.valid?).to eq(false)

      subject = described_class.new("     ")
      expect(subject.valid?).to eq(false)
    end

    it "returns false for an address without @" do
      subject = described_class.new("a")
      expect(subject.valid?).to eq(false)

      subject = described_class.new("john.doedomain.com")
      expect(subject.valid?).to eq(false)
    end

    it "returns false for an address with only an @" do
      subject = described_class.new("@")
      expect(subject.valid?).to eq(false)

      subject = described_class.new("  @  ")
      expect(subject.valid?).to eq(false)
    end

    it "returns false for an address with several @" do
      subject = described_class.new("john@doe@domain.com")
      expect(subject.valid?).to eq(false)
    end

    it "returns true for an address of length 255" do
      subject = described_class.new("a@#{(("a" * 49) + ".") * 5}com")
      expect(subject.valid?).to eq(true)
    end

    it "returns false for an address of length 256" do
      subject = described_class.new("ab@#{(("a" * 49) + ".") * 5}com")
      expect(subject.valid?).to eq(false)
    end

    context "considering the name part" do
      it "returns false for address without name part" do
        subject = described_class.new("@domain.com")
        expect(subject.valid?).to eq(false)
      end

      it "returns true for a name containing dots" do
        subject = described_class.new("john.doe.foo@domain.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns true for a name containing a plus" do
        subject = described_class.new("john.doe+test@domain.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns true for a name containing a dash" do
        subject = described_class.new("john-doe@domain.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns true for a name containing an underscore" do
        subject = described_class.new("john_doe@domain.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns true for a name containing a percent" do
        subject = described_class.new("john.doe%test@domain.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns false for a name containing non ascii char" do
        subject = described_class.new("john.dôe@domain.com")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for a name longer than 64 chars" do
        subject = described_class.new("#{"a" * 64}@domain.com")
        expect(subject.valid?).to eq(true)

        subject = described_class.new("#{"a" * 65}@domain.com")
        expect(subject.valid?).to eq(false)
      end
    end

    context "considering the domain part" do
      it "returns false for address without domain part" do
        subject = described_class.new("john.doe@")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for a domain containing non ascii char" do
        subject = described_class.new("john.doe@dômain.com")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for no fully qualified domain" do
        subject = described_class.new("john.doe@domain")
        expect(subject.valid?).to eq(false)

        subject = described_class.new("john.doe@my-domain")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for an IP address as domain" do
        subject = described_class.new("john.doe@12.23.34.45")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for the localhost domain" do
        subject = described_class.new("john.doe@localhost")
        expect(subject.valid?).to eq(false)
      end

      it "returns true for a domain having one part of 63 chars" do
        subject = described_class.new("john.doe@domain.#{"a" * 63}.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns false for a domain having one part of 64 chars" do
        subject = described_class.new("john.doe@domain.#{"a" * 64}.com")
        expect(subject.valid?).to eq(false)
      end

      context "considering dashes" do
        it "returns true for a domain with a dash" do
          subject = described_class.new("john.doe@my-domain.com")
          expect(subject.valid?).to eq(true)
        end

        it "returns false for a domain with successive dashes" do
          subject = described_class.new("john.doe@my--domain.com")
          expect(subject.valid?).to eq(false)

          subject = described_class.new("john.doe@my---domain.com")
          expect(subject.valid?).to eq(false)
        end

        it "returns false for a domain ending with a dash" do
          subject = described_class.new("john.doe@domain-.com")
          expect(subject.valid?).to eq(false)
        end

        it "returns false for a domain starting with a dash" do
          subject = described_class.new("john.doe@-domain.com")
          expect(subject.valid?).to eq(false)
        end
      end

      context "considering dots" do
        it "returns true for a domain with a dot" do
          subject = described_class.new("john.doe@my.domain.com")
          expect(subject.valid?).to eq(true)
        end

        it "returns false for a domain with successive dots" do
          subject = described_class.new("john.doe@my..domain.com")
          expect(subject.valid?).to eq(false)

          subject = described_class.new("john.doe@domain..com")
          expect(subject.valid?).to eq(false)

          subject = described_class.new("john.doe@domain...com")
          expect(subject.valid?).to eq(false)
        end

        it "returns false for a domain ending with a dot" do
          subject = described_class.new("john.doe@domain.com.")
          expect(subject.valid?).to eq(false)
        end

        it "returns false for a domain starting with a dot" do
          subject = described_class.new("john.doe@.domain.com")
          expect(subject.valid?).to eq(false)
        end
      end
    end
  end
end
