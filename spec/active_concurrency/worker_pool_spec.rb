# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::WorkerPool do
  let(:scheduler) do
    { type: ActiveConcurrency::Schedulers::RoundRobin }
  end
  let(:pool) { ActiveConcurrency::WorkerPool.new(10, scheduler: scheduler) }
  let(:results) { {} }

  let(:result_pool) do
    {
      'worker_0'=>0, 'worker_1'=>0, 'worker_2'=>0,
      'worker_3'=>0, 'worker_4'=>0, 'worker_5'=>0,
      'worker_6'=>0, 'worker_7'=>0, 'worker_8'=>0,
      'worker_9'=>0
    }
  end

  describe '.clear' do
    it 'returns hash with 0 workers' do
      enqueue_pool(2)
      pool.clear

      expect(pool.size).to eq(result_pool)
    end
  end

  describe '.size' do
    it 'returns hash with 10 enqueued workers and 0 jobs' do
      expect(pool.size).to eq(result_pool)
    end

    it 'returns hash with 10 enqueued workers and 2 jobs' do
      enqueue_pool(2)

      result_pool['worker_0'] = 1
      result_pool['worker_1'] = 1

      expect(pool.size).to eq(result_pool)
    end
  end

  describe '.wait' do
    it 'returns a hash all fib sequences from 0 to 29' do
      Thread.new do
        enqueue_pool(30)
        pool.done
      end

      pool.wait

      expect(results).to eq({
        0=>0, 1=>1, 2=>1, 3=>2, 4=>3,
        5=>5, 6=>8, 7=>13, 8=>21, 9=>34,
        10=>55, 11=>89, 12=>144, 13=>233, 14=>377,
        15=>610, 16=>987, 17=>1597, 18=>2584, 19=>4181,
        20=>6765, 21=>10946, 22=>17711, 23=>28657, 24=>46368,
        25=>75025, 26=>121393, 27=>196418, 28=>317811, 29=>514229
      })
    end
  end

  def fib(n)
    n < 2 ? n : fib(n - 1) + fib(n - 2)
  end

  def enqueue_pool(number_of_pools)
    number_of_pools.times do |n|
      pool << -> { results[n] = fib(n) }
    end
  end

end
