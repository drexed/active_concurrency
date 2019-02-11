# frozen_string_literal: true

require 'securerandom'
require 'thread'

module ActiveConcurrency
  class Worker

    attr_reader :name

    def initialize(name: SecureRandom.uuid)
      @name = name
      @queue = Queue.new
      @thread = Thread.new("worker_#{name}") { perform }
    end

    def clear
      @queue.clear
    end

    def done
      schedule { throw :exit }
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
      done
      join
    end

    def status
      @thread.status
    end

    private

    def perform
      catch(:exit) do
        loop do
          job, args = @queue.pop
          job.call(*args)
        end
      end
    end

  end
end
