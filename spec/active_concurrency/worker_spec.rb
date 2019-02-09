# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Worker do
  let(:worker) { ActiveConcurrency::Worker.new('worker_0') }
  let(:results) { [] }

  describe '.clear' do
    it 'returns hash with zero workers' do
      enqueue_jobs(2)

      worker.clear

      expect(worker.size).to eq(0)
    end
  end

  describe '.join' do
    it 'returns an array with all "job_*" in it' do
      Thread.new do
        enqueue_jobs(2)
        worker << :done
      end

      worker.join

      expect(results).to eq(%w[job_0 job_1])
    end
  end

  describe '.name' do
    it 'return "worker_0" name' do
      expect(worker.name).to eq('worker_0')
    end
  end

  describe '.size' do
    it 'returns 0 enqueued jobs' do
      expect(worker.size).to eq(0)
    end

    it 'returns 2 enqueued jobs' do
      enqueue_jobs(2)

      expect(worker.size).to eq(2)
    end
  end

  def enqueue_jobs(number_of_jobs)
    number_of_jobs.times do |n|
      worker << -> { results.push("job_#{n}") }
    end
  end

end
