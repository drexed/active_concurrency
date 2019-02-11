# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Schedulers::LeastBusy do
  let(:results) { {} }
  let(:pool) do
    ActiveConcurrency::WorkerPool.new(
      size: 10,
      scheduler: ActiveConcurrency::Schedulers::LeastBusy
    )
  end

  let(:result_pool) do
    {
      'worker_0'=>2, 'worker_1'=>2, 'worker_2'=>2,
      'worker_3'=>1, 'worker_4'=>1, 'worker_5'=>1,
      'worker_6'=>1, 'worker_7'=>1, 'worker_8'=>1,
      'worker_9'=>1
    }
  end

  describe '.size' do
    it 'returns hash with 10 scheduled workers and 13 jobs spread by least busy' do
      schedule_pool_jobs(13)

      expect(pool.sizes).to eq(result_pool)
    end
  end

end
