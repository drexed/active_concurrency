# frozen_string_literal: true

# TODO:
# - Add more scheduling algorithm
#   - https://www.cs.uic.edu/~jbell/CourseNotes/OperatingSystems/5_CPU_Scheduling.html

require 'active_concurrency/version'

%w[least_busy round_robin topic].each do |file_name|
  require "active_concurrency/schedulers/#{file_name}"
end

%w[base processes threads].each do |dir_name|
  %w[worker pool].each do |file_name|
    require "active_concurrency/#{dir_name}/#{file_name}"
  end
end

module ActiveConcurrency
  class Error < StandardError; end
end
