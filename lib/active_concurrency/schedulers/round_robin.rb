# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class RoundRobin

      def initialize(pool, options: {})
        @worker = pool.cycle
      end

      def schedule(*args, &block)
        @worker.next.schedule(*args, &block)
      end

    end
  end
end
