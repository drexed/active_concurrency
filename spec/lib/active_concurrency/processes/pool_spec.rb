# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Processes::Pool do
  let(:pool) { ActiveConcurrency::Processes::Pool.new(size: 10) }

  let(:worker_pool) do
    {
      'processes_worker_0'=>0, 'processes_worker_1'=>0, 'processes_worker_2'=>0,
      'processes_worker_3'=>0, 'processes_worker_4'=>0, 'processes_worker_5'=>0,
      'processes_worker_6'=>0, 'processes_worker_7'=>0, 'processes_worker_8'=>0,
      'processes_worker_9'=>0
    }
  end

  describe '.sizes' do
    it 'returns hash with 10 scheduled workers and 0 jobs' do
      expect(pool.sizes).to eq(worker_pool)
    end

    it 'returns hash with 10 scheduled workers and 2 jobs' do
      schedule_pool_jobs(2)
      update_worker_pool(worker_pool, '=', 1, break_i: 1)

      expect(pool.sizes).to eq(worker_pool)
    end
  end

  describe '.statuses' do
    it 'returns hash with 10 scheduled workers and "run" status' do
      update_worker_pool(worker_pool, '=', 'run')

      expect(pool.statuses).to eq(worker_pool)
    end

    it 'returns hash with 10 scheduled workers and false status' do
      schedule_pool_jobs(2, file: true)
      pool.shutdown
      update_worker_pool(worker_pool, '=', false)

      expect(pool.statuses).to eq(worker_pool)
    end
  end

  describe '.shutdown' do
    it 'returns a hash all fib sequences from 0 to 29' do
      schedule_pool_jobs(30, file: true)
      pool.shutdown

      expect(read_file.sort).to eq([
        0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144,
        233, 377, 610, 987, 1597, 2584, 4181, 6765,
        10946, 17711, 28657, 46368, 75025, 121393,
        196418, 317811, 514229
      ])
    end
  end

end
