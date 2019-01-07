# frozen_string_literal: true

module EmailInquire
  module Helper

    extend self

    def first_value(array, &block)
      array.lazy.map(&block).find(&:itself)
    end

  end
end
