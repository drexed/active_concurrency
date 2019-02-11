# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class RoundRobin

      def initialize(pool, options: {})
        @worker = pool.cycle
      end

      def enqueue(*args, &block)
        @worker.next.enqueue(*args, &block)
      end

    end
  end
end
