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

  # describe '.sizes' do
  #   it 'returns hash with 10 scheduled workers and 0 jobs' do
  #     expect(pool.sizes).to eq(worker_pool)
  #   end
  #
  #   it 'returns hash with 10 scheduled workers and 2 jobs' do
  #     schedule_pool_jobs(2)
  #     update_worker_pool(worker_pool, '=', 1, break_i: 1)
  #
  #     expect(pool.sizes).to eq(worker_pool)
  #   end
  # end
  #
  # describe '.statuses' do
  #   it 'returns hash with 10 scheduled workers and "run" status' do
  #     update_worker_pool(worker_pool, '=', 'run')
  #
  #     expect(pool.statuses).to eq(worker_pool)
  #   end
  #
  #   it 'returns hash with 10 scheduled workers and false status' do
  #     Thread.new do
  #       schedule_pool_jobs(2)
  #       pool.exit
  #     end
  #
  #     pool.join
  #     update_worker_pool(worker_pool, '=', false)
  #
  #     expect(pool.statuses).to eq(worker_pool)
  #   end
  # end

  # describe '.shutdown' do
  #   it 'returns a hash all fib sequences from 0 to 29' do
  #     schedule_pool_jobs(30, file: true)
  #     pool.shutdown
  #
  #     expect(read_file).to eq({
  #       0=>0, 1=>1, 2=>1, 3=>2, 4=>3,
  #       5=>5, 6=>8, 7=>13, 8=>21, 9=>34,
  #       10=>55, 11=>89, 12=>144, 13=>233, 14=>377,
  #       15=>610, 16=>987, 17=>1597, 18=>2584, 19=>4181,
  #       20=>6765, 21=>10946, 22=>17711, 23=>28657, 24=>46368,
  #       25=>75025, 26=>121393, 27=>196418, 28=>317811, 29=>514229
  #     })
  #   end
  # end

end
