# frozen_string_literal: true

module ActiveConcurrency
  class WorkerPool

    DEFAULT_SCHEDULER ||= ActiveConcurrency::Schedulers::RoundRobin

    attr_reader :pool

    def initialize(size: 2, scheduler: DEFAULT_SCHEDULER, **options)
      @pool = Array.new(size) { |n| Worker.new(name: n) }
      @scheduler = scheduler.new(@pool, options)
    end

    def clear
      @pool.map(&:clear)
    end

    def exit
      @pool.map(&:exit)
    end

    def schedule(*args, &block)
      @scheduler.schedule(*args, &block)
    end

    def join
      @pool.map(&:join)
    end

    def sizes
      @pool.each_with_object({}) do |w, h|
        h[w.name] = w.size
      end
    end

    def shutdown
      exit
      join
    end

    def statuses
      @pool.each_with_object({}) do |w, h|
        h[w.name] = w.status
      end
    end

  end
end
