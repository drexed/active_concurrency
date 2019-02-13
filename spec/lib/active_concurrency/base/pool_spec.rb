# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Threads::Pool do
  let(:pool) { ActiveConcurrency::Threads::Pool.new(size: 10) }

  let(:results) { {} }
  let(:worker_pool) do
    {
      'threads_worker_0'=>0, 'threads_worker_1'=>0, 'threads_worker_2'=>0,
      'threads_worker_3'=>0, 'threads_worker_4'=>0, 'threads_worker_5'=>0,
      'threads_worker_6'=>0, 'threads_worker_7'=>0, 'threads_worker_8'=>0,
      'threads_worker_9'=>0
    }
  end

  describe '.clear' do
    it 'returns hash with 0 workers' do
      schedule_pool_jobs(2)
      pool.clear

      expect(pool.sizes).to eq(worker_pool)
    end
  end

end
