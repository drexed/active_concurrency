# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class Topic

      def initialize(workers, topics)
        @workers = {}

        workers_per_topic = workers.size / topics.size
        workers.each_slice(workers_per_topic).each_with_index do |slice, index|
          topic = topics[index]
          @workers[topic] = slice
        end
      end

      def schedule(job)
        worker = @workers[job.topic].sort_by(&:size).first
        worker << job
      end

    end
  end
end
