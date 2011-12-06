require "spec_helper"

describe RfidApi::Device do
  include ModelsHelper
  
  it "should be valid" do
    RfidApi::Device.should be_a(Class)
  end
  
  it "should get devices" do
    FakeWeb.register_uri(:get, File.join(rfid_url, "devices.json"), 
      :body => [device_attrs, device_attrs("_id" => 2) ].to_json)
    
    devices = RfidApi::Device.all
    devices.should_not be_empty
  end
  
  it "should get one device" do
    attrs = device_attrs("_id" => "4e312bafc546615929000001")
    
    FakeWeb.register_uri(:get, File.join(rfid_url, "devices", "#{attrs['_id']}.json"), 
      :body => attrs.to_json)
    
    device = RfidApi::Device.find(attrs["_id"])
    
    attrs.each do |key, value|
      device.send(key).should == JSON.parse(value.to_json)
    end
  end
  
  context "create" do
    before(:each) do
      @attrs = device_attrs("title" => "Test device")
      @attrs.delete_if {|key, value| ["_id", "created_at", "updated_at", "relays"].include?(key) } 
    end
    
    it "should create new device" do
      FakeWeb.register_uri(:post, File.join(rfid_url, "devices.json"), 
        :body => '{"created_at":"2011-12-06T13:24:13+02:00","latitude":0.0,"secret_token":"sfoYxCgnYkCuNvZCpgxH","title":"Test device","updated_at":"2011-12-06T13:24:13+02:00","_id":"4eddfb5dc546612e14000063","longitude":0.0}')
            
      device = RfidApi::Device.create(@attrs)
      device.secret_token.should_not == @attrs['secret_token']
      device.title.should == @attrs['title']
      device.to_param.should_not be_blank
      device.should_not be_new_record
    end
    
    it "should not create new device with invalid params" do
      FakeWeb.register_uri(:post, File.join(rfid_url, "devices.json"), 
        :body => '{"created_at":null,"latitude":"wrong","secret_token":"2ny2RWAsSn7cRVlxmsVI","title":"","updated_at":null,"_id":"4eddfc65c546612e14000066","errors":{"title":["can\'t be blank"],"latitude":["is not a number"]},"longitude":0.0}')
      
      @attrs["title"] = ''
      @attrs["latitude"] = 'wrong'     
      
      device = RfidApi::Device.create(@attrs)
      device.secret_token.should_not == @attrs['secret_token']
      device.title.should == @attrs['title']
      device.latitude.should == @attrs['latitude']
      device.errors.should_not be_empty
    end
  end
end
