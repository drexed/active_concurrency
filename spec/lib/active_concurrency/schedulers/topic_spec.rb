# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Schedulers::Topic do
  let(:results) { {} }
  let(:pool) do
    ActiveConcurrency::Threads::Pool.new(
      size: 10,
      scheduler: ActiveConcurrency::Schedulers::Topic,
      topics: %w[topic_1 topic_2 topic_3]
    )
  end

  let(:worker_pool) do
    {
      'threads_worker_0'=>0, 'threads_worker_1'=>5, 'threads_worker_2'=>0,
      'threads_worker_3'=>0, 'threads_worker_4'=>4, 'threads_worker_5'=>0,
      'threads_worker_6'=>0, 'threads_worker_7'=>4, 'threads_worker_8'=>0,
      'threads_worker_9'=>0
    }
  end

  describe '.size' do
    it 'returns hash with 10 scheduled workers and 13 jobs spread sequentially over workers 1,4,7' do
      schedule_pool_jobs(13, 'topic_2')

      expect(pool.sizes).to eq(worker_pool)
    end
  end

end
