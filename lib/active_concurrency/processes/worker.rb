# frozen_string_literal: true

module ActiveConcurrency
  module Processes
    class Worker < ActiveConcurrency::Base::Worker

      def initialize(name: SecureRandom.uuid)
        super(name: name)
        @status = 'run'
      end

      def exit
        schedule { throw :exit }
      end

      def exit!
        Process.waitpid(@process)
        @status = false
      end

      def join
        @process = Process.fork do
          perform
          at_exit { exit! }
        end
      end

      def shutdown
        lock
        join
        exit!
      end

      def status
        @status
      end

      private

      def perform
        catch('HUP') { process }
      end

    end
  end
end
