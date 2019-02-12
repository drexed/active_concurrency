# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Threads::Worker do
  let(:worker) { ActiveConcurrency::Threads::Worker.new }
  let(:results) { [] }

  describe '.exit' do
    it 'returns 1 scheduled job' do
      worker.exit

      expect(worker.size).to eq(1)
    end
  end

  describe '.join' do
    it 'returns [0, 1]' do
      Thread.new do
        schedule_jobs(2)
        worker.exit
      end

      worker.join

      expect(results).to eq([0, 1])
    end
  end

  describe '.shutdown' do
    it 'returns [0, 1]' do
      schedule_jobs(2)
      worker.shutdown

      expect(results).to eq([0, 1])
    end
  end

  describe '.status' do
    it 'returns "run" status' do
      expect(worker.status).to eq('run')
    end

    it 'returns false status' do
      Thread.new do
        schedule_jobs(2)
        worker.exit
      end

      worker.join

      expect(worker.status).to eq(false)
    end
  end

end
