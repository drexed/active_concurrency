# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class RoundRobin

      def initialize(pool, **options)
        @pool = pool.cycle
      end

      def schedule(*args, &block)
        worker = @pool.next
        worker.schedule(*args, &block)
      end

    end
  end
end
