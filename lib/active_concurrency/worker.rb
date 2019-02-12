# frozen_string_literal: true

require 'securerandom'

module ActiveConcurrency
  class Worker

    attr_reader :name
    attr_accessor :mutex

    def initialize(name: SecureRandom.uuid)
      @name = "worker_#{name}"
      @queue = Queue.new
      @thread = Thread.new(@name) { perform }
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

    def lock
      return true if mutex.nil? || mutex.locked?

      mutex.lock
    end

    def schedule(*args, &block)
      @queue << [block, args]
    end

    def size
      @queue.size
    end

    def shutdown
      exit
      lock
      join
      close
      exit!
    end

    def status
      @thread.status
    end

    private

    def process
      job, args = @queue.pop

      if mutex.nil?
        job.call(*args)
      else
        mutex.synchronize { job.call(*args) }
      end
    end

    def perform
      catch(:exit) do
        loop do
          break if closed?

          begin
            process
          rescue Exception => e
            puts "Exception: #{e.message}\n#{e.backtrace}"
          end
        end
      end
    end

  end
end
