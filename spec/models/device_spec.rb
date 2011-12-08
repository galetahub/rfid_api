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
  
  it "should return nil if RFID service not available" do
    id = "4e312bafc546615929000001"
    FakeWeb.register_uri(:get, File.join(rfid_url, "devices", "#{id}.json"), 
      :body => '{"error":{"message":"Some error","info":"Some error"}}', :status => ["500", "Service not available"])
    
    device = RfidApi::Device.find(id)
    device.should be_nil
  end
  
  context "create/update/destroy" do
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
      device.should be_persisted
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
      device.should_not be_valid
      device.should_not be_persisted
    end
    
    it "should update device by id" do
      id = "4eddfb5dc546612e14000063"
      
      FakeWeb.register_uri(:put, File.join(rfid_url, "devices", "#{id}.json"), 
        :body => '{"created_at":"2011-12-06T13:24:13+02:00","latitude":0.0,"secret_token":"sfoYxCgnYkCuNvZCpgxH","title":"Update","updated_at":"2011-12-06T13:24:13+02:00","_id":"4eddfb5dc546612e14000063","longitude":0.0}')
      
      device = RfidApi::Device.update(id, :title => "Update")
      device.title.should == "Update"
      device.should be_valid
      device.should be_persisted
    end
    
    it "should destroy device by id" do
      id = "4eddfb5dc546612e14000063"
      
      FakeWeb.register_uri(:delete, File.join(rfid_url, "devices", "#{id}.json"), 
        :body => '{"created_at":"2011-12-06T13:24:13+02:00","latitude":0.0,"secret_token":"sfoYxCgnYkCuNvZCpgxH","title":"Noname","updated_at":"2011-12-06T13:24:13+02:00","_id":"4eddfb5dc546612e14000063","longitude":0.0}')
      
      device = RfidApi::Device.destroy(id)
      device.should be_destroyed
    end
  end
end
