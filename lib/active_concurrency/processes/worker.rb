# frozen_string_literal: true

module ActiveConcurrency
  module Processes
    class Worker < ActiveConcurrency::Base::Worker

      attr_reader :status

      def initialize(name: nil)
        super(name: name)
        @status = 'run'
      end

      def exit!
        Process.waitpid(@process) unless @process.nil?
        @status = false
      end

      def join
        @process = Process.fork do
          perform
          at_exit { exit! }
        end
      end

    end
  end
end
