# frozen_string_literal: true

module ActiveConcurrency
  class WorkerPool

    DEFAULT_SCHEDULER ||= {
      type: ActiveConcurrency::Schedulers::RoundRobin
    }.freeze

    def initialize(number_of_workers, scheduler: DEFAULT_SCHEDULER)
      @workers = Array.new(number_of_workers) { |n| ActiveConcurrency::Worker.new("worker_#{n}") }
      @scheduler = schedule_by_type(scheduler)
    end

    def clear
      @workers.map(&:clear)
    end

    def done
      enqueue(:done)
    end

    def enqueue(job)
      return shutdown if job == :done

      @scheduler.schedule(job)
    end

    alias_method :<<, :enqueue

    def size
      @workers.each_with_object({}) do |w, h|
        h[w.name] = w.size
      end
    end

    def shutdown
      @workers.map(&:done)
    end

    def wait
      @workers.map(&:join)
    end

    private

    def schedule_by_type(scheduler)
      case scheduler[:type].to_s
      when 'ActiveConcurrency::Schedulers::Topic'
        scheduler[:type].new(@workers, scheduler[:topics])
      else
        scheduler[:type].new(@workers)
      end
    end

  end
end
