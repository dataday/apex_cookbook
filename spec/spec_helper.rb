# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'
# https://github.com/bblimke/webmock
require 'webmock/rspec'

ChefSpec::Coverage.start!

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # Specify the path for Chef Solo file cache path (default: nil)
  config.file_cache_path = '/tmp/kitchen/cache'

  # Specify the Chef log_level (default: :warn)
  config.log_level = :debug

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
