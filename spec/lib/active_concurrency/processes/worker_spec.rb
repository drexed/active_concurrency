# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Processes::Worker do
  let(:worker) { ActiveConcurrency::Processes::Worker.new }

  describe '.status' do
    it 'returns "run" status' do
      expect(worker.status).to eq('run')
    end

    it 'returns false status' do
      worker.shutdown

      expect(worker.status).to eq(false)
    end
  end

  describe '.shutdown' do
    it 'returns [0, 1]' do
      schedule_worker_jobs(2, file: true)
      worker.shutdown

      expect(read_file).to eq([0, 1])
    end
  end

end
