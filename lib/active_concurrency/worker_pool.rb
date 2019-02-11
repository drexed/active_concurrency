# frozen_string_literal: true

module ActiveConcurrency
  class WorkerPool

    def initialize(size: 2, scheduler: Schedulers::RoundRobin, options: {})
      @pool = Array.new(size) { |n| Worker.new(name: n) }
      @scheduler = scheduler.new(@pool, options: options)
    end

    def clear
      @pool.map(&:clear)
    end

    def exit
      @pool.map(&:exit)
    end

    def enqueue(*args, &block)
      @scheduler.enqueue(*args, &block)
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
      @pool.map(&:shutdown)
    end

    def statuses
      @pool.each_with_object({}) do |w, h|
        h[w.name] = w.status
      end
    end

  end
end
