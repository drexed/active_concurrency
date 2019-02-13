# frozen_string_literal: true

module ActiveConcurrency
  module Base
    class Pool

      DEFAULT_SCHEDULER ||= ActiveConcurrency::Schedulers::LeastBusy

      def initialize(size: 2, scheduler: DEFAULT_SCHEDULER, **options)
        size = [size, options[:topics].size].max if options.key?(:topics)
        @pool = Array.new(size) { |n| worker.new(name: n) }
        @scheduler = scheduler.new(@pool, options)
      end

      def clear
        @pool.map(&:clear)
      end

      def close
        @pool.map(&:close)
      end

      def closed
        @pool.each_with_object({}) do |w, h|
          h[w.name] = w.closed?
        end
      end

      def exit
        @pool.map(&:exit)
      end

      def exit!
        @pool.map(&:exit!)
      end

      def schedule(*args, &block)
        @scheduler.schedule(*args, &block)
      end

      def join
        @pool.map(&:join)
      end

      def lock
        @pool.map(&:lock)
      end

      def sizes
        @pool.each_with_object({}) do |w, h|
          h[w.name] = w.size
        end
      end

      def shutdown
        @pool.map(&:shutdown)
      end

      def statuses
        @pool.each_with_object({}) do |w, h|
          h[w.name] = w.status
        end
      end

      private

      def worker
        modules = self.class.name.split('::')[0..1]
        klass = modules.push('Worker').join('::')
        ::Object.const_get(klass)
      end

    end
  end
end
