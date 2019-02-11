# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Schedulers::Topic do
  let(:results) { {} }
  let(:pool) do
    ActiveConcurrency::WorkerPool.new(
      size: 10,
      scheduler: ActiveConcurrency::Schedulers::Topic,
      topics: %w[topic_1 topic_2 topic_3]
    )
  end

  let(:result_pool) do
    {
      'worker_0'=>0, 'worker_1'=>5, 'worker_2'=>0,
      'worker_3'=>0, 'worker_4'=>4, 'worker_5'=>0,
      'worker_6'=>0, 'worker_7'=>4, 'worker_8'=>0,
      'worker_9'=>0
    }
  end

  describe '.size' do
    it 'returns hash with 10 scheduled workers and 13 jobs spread sequentially over workers 1,4,7' do
      schedule_pool_jobs(13, 'topic_2')

      expect(pool.sizes).to eq(result_pool)
    end
  end

end
