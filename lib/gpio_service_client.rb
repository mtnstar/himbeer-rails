require 'json'
require 'yaml'
require 'net/http'

class GpioServiceClient

  VALUE_ON = 0;
  VALUE_OFF = 1;
  VALUES = [VALUE_ON, VALUE_OFF]

  def initialize
    config = YAML.load_file('config/gpio_service_client.yaml')[Rails.env]
    @host = config["host"]
    @port = config["port"]
  end

  def toggle(pin)
    current_value = read_gpio(pin)['value']
    if VALUES.include?(current_value)
      new_value = VALUE_ON
      if current_value == VALUE_ON
        new_value = VALUE_OFF
      end
      update_gpio(pin, new_value)
    end
  end

  def update_gpio(pin, value)
    data = {pin: pin, value: value}.to_json
    p data
    http_post(data)
  end

  def read_gpio(pin)
    data = {pin: pin}.to_json
    http_post(data)
  end

  private
  def http_post(data)
    req = Net::HTTP::Post.new('/', initheader = {'Content-Type' =>'application/json'})
    req.body = data
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    JSON.parse(response.body)
  end
end
