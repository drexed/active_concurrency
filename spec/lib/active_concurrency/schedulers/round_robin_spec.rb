# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Schedulers::RoundRobin do
  let(:results) { {} }
  let(:pool) do
    ActiveConcurrency::Threads::Pool.new(
      size: 10,
      scheduler: ActiveConcurrency::Schedulers::RoundRobin
    )
  end

  let(:worker_pool) do
    {
      'threads_worker_0'=>2, 'threads_worker_1'=>2, 'threads_worker_2'=>2,
      'threads_worker_3'=>1, 'threads_worker_4'=>1, 'threads_worker_5'=>1,
      'threads_worker_6'=>1, 'threads_worker_7'=>1, 'threads_worker_8'=>1,
      'threads_worker_9'=>1
    }
  end

  describe '.size' do
    it 'returns hash with 10 scheduled workers and 13 jobs spread sequentially' do
      schedule_pool_jobs(13)

      expect(pool.sizes).to eq(worker_pool)
    end
  end

end
