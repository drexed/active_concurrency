# frozen_string_literal: true

require 'securerandom'

module ActiveConcurrency
  module Base
    class Worker

      attr_reader :name
      attr_accessor :mutex

      def initialize(name: SecureRandom.uuid)
        @name = "#{prefix}_worker_#{name}"
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
        self.class.name.split('::')[1].downcase
      end

      def process
        loop do
          break if closed?

          begin
            execute
          rescue Exception => e
            puts "#{e.class.name}: #{e.message}"
          end

          break if empty?
        end
      end

    end
  end
end
