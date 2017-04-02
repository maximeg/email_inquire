# frozen_string_literal: true

require "spec_helper"

describe EmailInquire::EmailValidator do
  describe "#valid?" do
    it "returns true for a valid address" do
      subject = described_class.new("john.doe@example.com")
      expect(subject.valid?).to eq(true)
    end

    it "returns false for an address without @" do
      subject = described_class.new("john.doeexample.com")
      expect(subject.valid?).to eq(false)
    end

    it "returns false for an address with several @" do
      subject = described_class.new("john@doe@example.com")
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

    context "considering name part" do
      it "returns false for address without name part" do
        subject = described_class.new("@example.com")
        expect(subject.valid?).to eq(false)
      end

      it "returns true for name containing dots" do
        subject = described_class.new("john.doe.foo@example.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns true for name containing a plus" do
        subject = described_class.new("john.doe+test@example.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns true for name containing a dash" do
        subject = described_class.new("john-doe@example.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns true for name containing an underscore" do
        subject = described_class.new("john_doe@example.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns true for name containing a percent" do
        subject = described_class.new("john.doe%test@example.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns false for name containing non ascii char" do
        subject = described_class.new("john.dôe@example.com")
        expect(subject.valid?).to eq(false)
      end
    end

    context "considering domain part" do
      it "returns false for address without domain part" do
        subject = described_class.new("john.doe@")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for domain containing non ascii char" do
        subject = described_class.new("john.doe@exâmple.com")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for no fully qualified domain" do
        subject = described_class.new("john.doe@example")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for an IP address as domain" do
        subject = described_class.new("john.doe@12.23.34.45")
        expect(subject.valid?).to eq(false)
      end

      it "returns false for localhost domain" do
        subject = described_class.new("john.doe@localhost")
        expect(subject.valid?).to eq(false)
      end

      it "returns true for domain having one part of 63 chars" do
        subject = described_class.new("john.doe@example.#{"a" * 63}.com")
        expect(subject.valid?).to eq(true)
      end

      it "returns false for domain having one part of 64 chars" do
        subject = described_class.new("john.doe@example.#{"a" * 64}.com")
        expect(subject.valid?).to eq(false)
      end

      context "considering dashes" do
        it "returns true for domain with a dash" do
          subject = described_class.new("john.doe@example-foo.com")
          expect(subject.valid?).to eq(true)
        end

        it "returns false for domain with successive dashes" do
          subject = described_class.new("john.doe@example--foo.com")
          expect(subject.valid?).to eq(false)

          subject = described_class.new("john.doe@example---foo.com")
          expect(subject.valid?).to eq(false)
        end

        it "returns false for domain ending with a dash" do
          subject = described_class.new("john.doe@example-.com")
          expect(subject.valid?).to eq(false)
        end

        it "returns false for domain starting with a dash" do
          subject = described_class.new("john.doe@-example.com")
          expect(subject.valid?).to eq(false)
        end
      end

      context "considering dots" do
        it "returns true for domain with a dot" do
          subject = described_class.new("john.doe@example.foo.com")
          expect(subject.valid?).to eq(true)
        end

        it "returns false for domain with successive dots" do
          subject = described_class.new("john.doe@example..foo.com")
          expect(subject.valid?).to eq(false)

          subject = described_class.new("john.doe@example..com")
          expect(subject.valid?).to eq(false)

          subject = described_class.new("john.doe@example...com")
          expect(subject.valid?).to eq(false)
        end

        it "returns false for domain ending with a dot" do
          subject = described_class.new("john.doe@example.com.")
          expect(subject.valid?).to eq(false)
        end

        it "returns false for domain starting with a dot" do
          subject = described_class.new("john.doe@.example.com")
          expect(subject.valid?).to eq(false)
        end
      end
    end
  end
end
