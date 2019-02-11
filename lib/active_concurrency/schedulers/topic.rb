# frozen_string_literal: true

module ActiveConcurrency
  module Schedulers
    class Topic

      def initialize(pool, **options)
        topics = options[:topics].cycle
        @pool = pool.each_with_object({}) do |w, h|
          topic = topics.next
          h.key?(topic) ? (h[topic] << w) : (h[topic] = [w])
        end
      end

      def schedule(*args, &block)
        topic = args.pop
        worker = @pool[topic].min_by(&:size)
        worker.schedule(*args, &block)
      end

    end
  end
end
