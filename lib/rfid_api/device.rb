module RfidApi
  class Device < Client
    self.resource_name = "device"
    
    def events(options = {})
      resources get("/#{plural_name}/#{_id}/events.#{format}", :query => options)
    end
    
    def actions(options = {})
      resources get("/#{plural_name}/#{_id}/actions.#{format}", :query => options)
    end
  end
end
