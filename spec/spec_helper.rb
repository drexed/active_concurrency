# frozen_string_literal: true

%w[bundler/setup active_concurrency pathname].each do |file_name|
  require file_name
end

support_path = File.expand_path('../spec/support', File.dirname(__FILE__))
support_path = Pathname.new(support_path)

%w[rspec/file_helpers.rb rspec/job_helpers.rb].each do |file_name|
  load(support_path.join(file_name))
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Custom RSpec helpers
  config.include FileHelpers
  config.include JobHelpers
end
