# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class LeastBusy

      def initialize(pool, options: {})
        @pool = pool
      end

      def schedule(job)
        worker = @pool.sort_by(&:size).first
        worker << job
      end

    end
  end
end
