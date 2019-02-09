# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveConcurrency do

  it 'returns a version number' do
    expect(ActiveConcurrency::VERSION).not_to be nil
  end

end
