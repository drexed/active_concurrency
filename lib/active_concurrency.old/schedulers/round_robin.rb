# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class RoundRobin

      def initialize(workers)
        @current_worker = workers.cycle
      end

      def schedule(job)
        @current_worker.next << job
      end

    end
  end
end
