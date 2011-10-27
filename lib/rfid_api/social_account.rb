module RfidApi
  class SocialAccount < Client
    self.resource_name = "social_account"
    
    def cards(options = {})
      resources get("/#{plural_name}/#{_id}/cards.#{format}", :query => options)
    end
  end
end
