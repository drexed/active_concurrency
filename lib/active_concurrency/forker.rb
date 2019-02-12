# frozen_string_literal: true

module ActiveConcurrency
  class Forker

    attr_accessor :mutex

    def initialize
      @queue = Queue.new
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
      pgid = Process.getpgid(@process)
      Process.kill('HUP', -pgid)
      Process.detach(pgid)
    end

    def join
      @process = Process.fork { perform }
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
      join
      exit
    end

    def status
      @process.last_status
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
      Process.setsid

      catch('HUP') do
        loop do
          break if closed? || empty?

          begin
            process
          rescue Exception => e
            puts "#{e.class.name}: #{e.message}"
          end
        end
      end
    end

  end
end
