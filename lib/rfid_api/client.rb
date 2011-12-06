require "active_support/core_ext"
require "active_model"
require "httparty"
require "ostruct"
require "yajl/json_gem"

module RfidApi
  class Client < ::OpenStruct
    include ::HTTParty
    
    extend ::ActiveModel::Naming
    
    # https://rfidapi.aimbulance.com/api/v1/devices.xml
    base_uri File.join("https://rfidapi.aimbulance.com", "api", RfidApi.api_version)
    basic_auth RfidApi.username, RfidApi.password
    format RfidApi.format
    debug_output RfidApi.logger
    
    delegate :create, :update, :get, :plural_name, :format, :resources, :to => "self.class"
    
    attr_reader :errors
    
    class << self
    
      # Gets the resource_name
      def resource_name
        # Not using superclass_delegating_reader. See +site+ for explanation
        if defined?(@resource_name)
          @resource_name
        elsif superclass != Object && superclass.proxy
          superclass.proxy.dup.freeze
        end
      end
      
      # Set resource_name
      def resource_name=(name)
        @resource_name = name
      end
      
      def create(attributes)
        response = post("/#{plural_name}.#{format}", :body => { singular_name => attributes })
        resource(response, attributes)
      end
      
      def update(id, attributes)
        response = put("/#{plural_name}/#{id}.#{format}", :body => { singular_name => attributes })
        resource(response, attributes)
      end
      
      def all(options = {})
        resources get("/#{plural_name}.#{format}", :query => options)
      end
      
      def find(id, options = {})
        resource get("/#{plural_name}/#{id}.#{format}", :query => options)
      end
      
      def destroy(id)
        resource delete("/#{plural_name}/#{id}.#{format}")
      end
      
      def model_name
        @_model_name ||= ActiveModel::Name.new(self)
      end
      
      protected
        
        def singular_name
          @singular_name ||= resource_name.to_s.downcase.singularize
        end
        
        def plural_name
          @plural_name ||= resource_name.to_s.downcase.pluralize
        end
        
        def resources(response, attributes = {})
          if response && [200, 201, 422].include?(response.code)
            body = post_parse(response.parsed_response)
            [body].flatten.collect { |item| new(item) }
          end
        end
        
        def resource(resource, attributes = {})
          array = resources(resource, attributes)
          array.nil? ? nil : array.first
        end
        
        def post_parse(body)
          return body unless body.is_a?(String)
          
          case format
            when :json then Yajl::Parser.new.parse(body)
            when :xml then Nokogiri::XML.parse(body)
          end
        end
    end
    
    def to_key
      [_id]
    end
    
    def to_param
      _id
    end
    
    def save
      new_record? ? create(@table) : update(_id, @table)
    end
    
    def destroy
      unless new_record?
        self.class.destroy(_id)
        @destroyed = true
      end
    end
    
    def new_record?
      _id.blank?
    end
    
    def persisted?
      !(new_record? || destroyed?)
    end
    
    def destroyed?
      @destroyed == true
    end
    
    def valid?
      errors.empty?
    end
    
    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end
    
    def errors=(attributes)
      puts "errors"
      puts attributes.inspect
      
      attributes.each do |key, value|
        [value].flatten.each { |message| errors.add(key, message) }
      end
    end
    
    def read_attribute(name)
      @table[name.to_sym]
    end
    
    def write_attribute(name, value)
      @table[name.to_sym] = value
    end
    
    def datetime(colum_name)
      begin
        DateTime.parse(send(colum_name))
      rescue Exception => e
        nil
      end
    end      
  end
end
