# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Processes::Worker do
  let(:worker) { ActiveConcurrency::Processes::Worker.new }
  let(:results) { [] }

  describe '.join' do
    it 'returns [0, 1]' do
      schedule_jobs(2)
      worker.shutdown

      expect(results).to eq([0, 1])
    end
  end

end
