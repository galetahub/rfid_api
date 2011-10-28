module RfidApi
  class Action < Client
    self.resource_name = "action"
    
    class << self
      def find(device_id, id, options = {})
        resource get("/devices/#{device_id}/#{plural_name}/#{id}.#{format}", :query => options)
      end
      
      def create(device_id, attributes)
        response = post("/devices/#{device_id}/#{plural_name}.#{format}", :body => { singular_name => attributes })
        resource(response, attributes)
      end
      
      def update(device_id, id, attributes)
        resource put("/devices/#{device_id}/#{plural_name}/#{id}.#{format}", :body => { singular_name => attributes })
      end
      
      def destroy(device_id, id)
        resource delete("/devices/#{device_id}/#{plural_name}/#{id}.#{format}")
      end
    end
  end
end
