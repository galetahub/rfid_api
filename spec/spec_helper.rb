require "rubygems"
require "bundler/setup"

$:.push File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require "rfid_api"
require "fakeweb"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RfidApi.setup do |config|
  config.username = 'user'
  config.password = 'password'
  config.logger = nil
end

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers

  # == Mock Framework
  config.mock_with :rspec
  
  config.before(:suite) do
    FakeWeb.allow_net_connect = false
  end
  
  config.after(:suite) do
    FakeWeb.allow_net_connect = true
  end
end
