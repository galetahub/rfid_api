module RfidApi
  class Device < Client
    self.resource_name = "device"
    
    def events(options = {})
      resources get("/#{plural_name}/#{_id}/events.#{format}", :query => options)
    end
  end
end
