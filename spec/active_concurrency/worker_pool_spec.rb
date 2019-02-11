# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::WorkerPool do
  let(:pool) { ActiveConcurrency::WorkerPool.new(size: 10) }
  let(:results) { {} }

  let(:result_pool) do
    (0..9).each_with_object({}) { |n, h| h["worker_#{n}"] = 0 }
  end

  describe '.clear' do
    it 'returns hash with 0 workers' do
      schedule_pool_jobs(2)
      pool.clear

      expect(pool.sizes).to eq(result_pool)
    end
  end

  describe '.sizes' do
    it 'returns hash with 10 scheduled workers and 0 jobs' do
      expect(pool.sizes).to eq(result_pool)
    end

    it 'returns hash with 10 scheduled workers and 2 jobs' do
      schedule_pool_jobs(2)
      update_result_hash(result_pool, '=', 1, break_i: 1)

      expect(pool.sizes).to eq(result_pool)
    end
  end

  describe '.statuses' do
    it 'returns hash with 10 scheduled workers and "run" status' do
      update_result_hash(result_pool, '=', 'run')

      expect(pool.statuses).to eq(result_pool)
    end

    it 'returns hash with 10 scheduled workers and false status' do
      Thread.new do
        schedule_pool_jobs(2)
        pool.exit
      end

      pool.join
      update_result_hash(result_pool, '=', false)

      expect(pool.statuses).to eq(result_pool)
    end
  end

  describe '.join' do
    it 'returns a hash all fib sequences from 0 to 29' do
      Thread.new do
        schedule_pool_jobs(30)
        pool.exit
      end

      pool.join

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

end
