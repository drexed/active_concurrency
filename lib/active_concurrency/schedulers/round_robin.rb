# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class RoundRobin

      def initialize(pool, _options)
        mutex = Mutex.new
        @pool = pool.each { |w| w.mutex = mutex }.cycle
      end

      def schedule(*args, &block)
        worker = @pool.next
        worker.schedule(*args, &block)
      end

    end
  end
end
