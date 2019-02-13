# frozen_string_literal: true

module ActiveConcurrency
  module Threads
    class Pool < ActiveConcurrency::Base::Pool

      def exit!
        @pool.map(&:exit!)
      end

    end
  end
end
