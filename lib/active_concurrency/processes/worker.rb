# frozen_string_literal: true

module ActiveConcurrency
  module Processes
    class Worker < ActiveConcurrency::Base::Worker

      def exit
        # Process.kill('HUP', -@pgid)
      end

      def join
        pid = Process.fork { perform }
        Process.waitall
        # @pgid = Process.getpgid(pid)
        # Process.detach(@pgid)
      end

      def shutdown
        lock
        join
        exit
      end

      def status
        @process.last_status
      end

      private

      def perform
        Process.setsid
        catch('HUP') { process }
      end

    end
  end
end
