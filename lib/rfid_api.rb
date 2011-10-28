require 'active_support/core_ext/module/attribute_accessors'

module RfidApi
  autoload :Client, 'rfid_api/client'
  autoload :Device, 'rfid_api/device'
  autoload :Card, 'rfid_api/card'
  autoload :Event, 'rfid_api/event'
  autoload :SocialAccount, 'rfid_api/social_account'
  autoload :Action, 'rfid_api/action'
  
  mattr_accessor :username
  @@username = 'user'
  
  mattr_accessor :password
  @@password = 'password'
  
  mattr_accessor :format
  @@format = :json
  
  mattr_accessor :api_version
  @@api_version = 'v1'
  
  def self.setup
    yield self
  end
end
