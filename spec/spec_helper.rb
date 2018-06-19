require "bundler/setup"
require "rms_api_ruby"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # It causes the host group and examples to inherit metadata
  # from the shared context.
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
