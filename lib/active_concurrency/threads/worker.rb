# frozen_string_literal: true

module ActiveConcurrency
  module Threads
    class Worker < ActiveConcurrency::Base::Worker

      def initialize(name: nil)
        super(name: name)
        @thread = Thread.new(@name) { perform }
      end

      def exit!
        @thread.exit
      end

      def join
        @thread.join
      end

      def status
        @thread.status
      end

    end
  end
end
