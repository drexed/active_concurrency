# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency::Forker do
  let(:worker) { ActiveConcurrency::Forker.new }
  let(:results) { [] }

  describe '.join' do
    it 'returns [0, 1]' do
      schedule_jobs(2)
      worker.shutdown

      expect(results).to eq([0, 1])
    end
  end

end
