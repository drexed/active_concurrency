# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class LeastBusy

      def initialize(pool, _options)
        mutex = Mutex.new
        @pool = pool.each { |w| w.mutex = mutex }
      end

      def schedule(*args, &block)
        worker = @pool.min_by(&:size)
        worker.schedule(*args, &block)
      end

    end
  end
end
