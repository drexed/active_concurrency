# frozen_string_literal: true

module ActiveConcurrency
  class Worker

    attr_reader :name

    def initialize(name)
      @name = name
      @queue = Queue.new
      @thread = Thread.new { perform }
    end

    def clear
      @queue.clear
    end

    def dequeue
      @queue.pop
    end

    def done
      enqueue(:done)
    end

    alias_method :shutdown, :done

    def enqueue(job)
      @queue << job
    end

    alias_method :<<, :enqueue

    def join
      @thread.join
    end

    def size
      @queue.size
    end

    private

    def perform
      while (job = dequeue)
        break if job == :done

        job.call

        puts "#{name} got #{job}" # only for debugging
      end
    end

  end
end
