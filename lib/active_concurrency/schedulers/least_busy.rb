# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class LeastBusy

      def initialize(pool, **options)
        @pool = pool
      end

      def schedule(*args, &block)
        worker = @pool.sort_by(&:size).first
        worker.schedule(*args, &block)
      end

    end
  end
end
