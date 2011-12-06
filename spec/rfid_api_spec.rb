require 'spec_helper'

describe RfidApi do
  it "should be valid" do
    RfidApi.should be_a(Module)
  end
  
  context "setup" do
    before(:each) do
      RfidApi.setup do |config|
        config.username = "user"
        config.password = "pass"
        config.format = :json
        config.api_version = "v2"
      end
    end
    
    it "should set config options" do
      RfidApi.username.should == "user"
      RfidApi.password.should == "pass"
      RfidApi.format.should == :json
      RfidApi.api_version.should == "v2"
    end
  end
end
