module ModelsHelper
  def rfid_auth
    [RfidApi.username, RfidApi.password].join(':')
  end
  
  def rfid_url
    "https://#{rfid_auth}@rfidapi.aimbulance.com/api/v1"
  end
  
  def device_attrs(attrs = {})
    attrs = {
      "relays" => [],
      "created_at" => Time.now,
      "latitude" => 0,
      "secret_token" => "Tpj1gs26b5XJPikc36ST",
      "title" => "Noname",
      "updated_at" => Time.now,
      "_id" => "4e312bafc546615929000001",
      "longitude" => 0,
      "action_klass_name" => "DefaultAction"
    }.merge(attrs)
  end
end
