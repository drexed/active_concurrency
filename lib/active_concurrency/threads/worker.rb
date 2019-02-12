# frozen_string_literal: true

module ActiveConcurrency
  module Threads
    class Worker < ActiveConcurrency::Base::Worker

      def initialize(name: SecureRandom.uuid)
        super(name: name)
        @thread = Thread.new(@name) { perform }
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

      def perform
        catch(:exit) { process }
      end

    end
  end
end
