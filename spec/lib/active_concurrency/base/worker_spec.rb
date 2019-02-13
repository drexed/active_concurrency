# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Threads::Worker do
  let(:worker) { ActiveConcurrency::Threads::Worker.new(name: 0) }

  let(:results) { [] }

  describe '.clear' do
    it 'returns hash with zero workers' do
      schedule_worker_jobs(2)
      worker.clear

      expect(worker.size).to eq(0)
    end
  end

  describe '.closed?' do
    it 'returns false' do
      expect(worker.closed?).to eq(false)
    end

    it 'returns true' do
      worker.close

      expect(worker.closed?).to eq(true)
    end
  end

  describe '.empty?' do
    it 'returns true' do
      expect(worker.empty?).to eq(true)
    end

    it 'returns false on first enqueue' do
      schedule_worker_jobs(2)

      expect(worker.empty?).to eq(false)
    end

    it 'returns true on first enqueue' do
      schedule_worker_jobs(2)
      worker.exit
      worker.join

      expect(worker.empty?).to eq(true)
    end
  end

  describe '.exit' do
    it 'returns 1 scheduled job' do
      worker.exit

      expect(worker.size).to eq(1)
    end
  end

  describe '.name' do
    it 'return "worker_0" name' do
      expect(worker.name).to eq('threads_worker_0')
    end
  end

  describe '.schedule' do
    it 'returns 2 scheduled jobs' do
      schedule_worker_jobs(2)

      expect(worker.size).to eq(2)
    end
  end

  describe '.size' do
    it 'returns 0 scheduled jobs' do
      expect(worker.size).to eq(0)
    end

    it 'returns 2 scheduled jobs' do
      schedule_worker_jobs(2)

      expect(worker.size).to eq(2)
    end
  end

end
