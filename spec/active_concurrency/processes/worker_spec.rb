# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Processes::Worker do
  let(:worker) { ActiveConcurrency::Processes::Worker.new }
  let(:results) { [] }

  # describe '.status' do
  #   it 'returns "run" status' do
  #     worker.shutdown
  #
  #     expect(worker.status).to eq('ru')
  #   end
  # end

  describe '.shutdown' do
    it 'returns [0, 1]' do
      schedule_jobs(2)
      worker.shutdown

      expect(results).to eq([0, 1, 2])
    end
  end

end
