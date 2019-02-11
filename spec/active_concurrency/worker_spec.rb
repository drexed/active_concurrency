# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Worker do
  let(:worker) { ActiveConcurrency::Worker.new(name: 0) }
  let(:results) { [] }

  describe '.clear' do
    it 'returns hash with zero workers' do
      schedule_jobs(2)
      worker.clear

      expect(worker.size).to eq(0)
    end
  end

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

  describe '.name' do
    it 'return "worker_0" name' do
      expect(worker.name).to eq('worker_0')
    end
  end

  describe '.schedule' do
    it 'returns 2 scheduled jobs' do
      schedule_jobs(2)

      expect(worker.size).to eq(2)
    end
  end

  describe '.size' do
    it 'returns 0 scheduled jobs' do
      expect(worker.size).to eq(0)
    end

    it 'returns 2 scheduled jobs' do
      schedule_jobs(2)

      expect(worker.size).to eq(2)
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
