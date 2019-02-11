# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class Topic

      def initialize(pool, options: {})
        @pool = {}

        pool_per_topic = pool.size / topics.size
        pool.each_slice(pool_per_topic).each_with_index do |slice, index|
          topic = topics[index]
          @pool[topic] = slice
        end
      end

      def schedule(job)
        worker = @pool[job.topic].sort_by(&:size).first
        worker << job
      end

    end
  end
end
