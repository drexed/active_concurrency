# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::WorkerPool do
  let(:scheduler) do
    {
      type: ActiveConcurrency::Schedulers::Topic,
      topics: %w[topic_0 topic_1]
    }
  end
  let(:pool) { ActiveConcurrency::WorkerPool.new(10, scheduler: scheduler) }
  let(:results) { {} }

  let(:result_pool) do
    {
      'worker_0'=>2, 'worker_1'=>1, 'worker_2'=>1,
      'worker_3'=>1, 'worker_4'=>1, 'worker_5'=>1,
      'worker_6'=>1, 'worker_7'=>1, 'worker_8'=>1,
      'worker_9'=>2
    }
  end

  describe '.size' do
    it 'returns hash with 10 enqueued workers and properly spread jobs' do
      enqueue_pool(12)

      expect(pool.size).to eq(result_pool)
    end
  end

  def enqueue_pool(number_of_pools)
    number_of_pools.times do |n|
      pool << -> { results[n] = 'pool_#{n}' }
    end
  end

end
