# frozen_string_literal: true

module ActiveConcurrency
  class Forker < ActiveConcurrency::Base

    def exit
      pgid = Process.getpgid(@process)
      Process.kill('HUP', -pgid)
      Process.detach(pgid)
    end

    def join
      @process = Process.fork { perform }
    end

    def shutdown
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
