# frozen_string_literal: true

require 'securerandom'

module ActiveConcurrency
  module Base
    class Worker

      attr_reader :name
      attr_accessor :mutex

      def initialize(name: nil)
        @name = "#{prefix}_worker_#{name || SecureRandom.uuid}"
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
        schedule { throw :exit }
      end

      def lock
        return true if mutex.nil? || mutex.locked?

        mutex.lock
      end

      def schedule(*args, &block)
        @queue << [block, args]
      end

      def shutdown
        exit
        lock
        join
        close
        exit!
      end

      def size
        @queue.size
      end

      private

      def execute
        job, args = @queue.pop

        if mutex.nil?
          job.call(*args)
        else
          mutex.synchronize { job.call(*args) }
        end
      end

      def prefix
        klass = self.class.name.split('::')[1]
        klass.downcase
      end

      def perform
        catch(:exit) do
          loop do
            break if closed? || empty?

            begin
              execute
            rescue Exception => e
              puts "#{e.class.name}: #{e.message}"
            end
          end
        end
      end

    end
  end
end
