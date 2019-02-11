# frozen_string_literal: true

require 'securerandom'

module ActiveConcurrency
  class Worker

    attr_reader :name, :queue, :thread

    def initialize(name: SecureRandom.uuid)
      @name = "worker_#{name}"
      @queue = Queue.new
      @thread = spawn
    end

    def clear
      @queue.clear
    end

    def close
      @queue.close
    end

    def closed?
      @queue.closed?
    end

    def empty?
      @queue.empty?
    end

    def exit
      schedule { throw :exit }
    end

    def exit!
      @thread.exit
    end

    def join
      @thread.join
    end

    def schedule(*args, &block)
      @queue << [block, args]
    end

    def size
      @queue.size
    end

    def shutdown
      exit && join && close && exit!
    end

    def status
      @thread.status
    end

    private

    def perform
      catch(:exit) do
        loop do
          break if closed?

          job, args = @queue.pop
          job.call(*args)
        end
      end
    end

    def spawn
      Thread.new(@name) { perform }
    end

  end
end
