# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class LeastBusy

      def initialize(workers)
        @workers = workers
      end

      def schedule(job)
        worker = @workers.sort_by(&:size).first
        worker << job
      end

    end
  end
end
