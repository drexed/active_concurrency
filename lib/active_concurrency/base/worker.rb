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
        return true if process? || mutex.nil? || mutex.locked?

        mutex.lock
      end

      def schedule(*args, &block)
        @queue << [block, args]
      end

      # rubocop:disable Lint/UnreachableCode
      def shutdown
        exit
        lock
        join
        close
        exit!
      end
      # rubocop:enable Lint/UnreachableCode

      def size
        @queue.size
      end

      private

      def execute
        job, args = @queue.pop

        if mutex.nil? || process?
          job.call(*args)
        else
          mutex.synchronize { job.call(*args) }
        end
      end

      def prefix
        @prefix ||= begin
          klass = self.class.name.split('::')[1]
          klass.downcase
        end
      end

      def perform
        catch(:exit) do
          loop do
            break if closed? || empty?

            begin
              execute
            rescue Exception => e
              puts "#{e.class.name}: #{e.message}\n#{e.backtrace.join("\n")}"
            end
          end
        end
      end

      def process?
        prefix == 'processes'
      end

      def thread?
        prefix == 'threads'
      end

    end
  end
end
