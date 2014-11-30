require 'json'
require 'yaml'
require 'net/http'

class GpioServiceClient

  ON_OFF_DEVICE = {on: 0, off: 1}

  def initialize
    config = YAML.load_file('config/gpio_service_client.yaml')[Rails.env]
    @host = config["host"]
    @port = config["port"]
  end

  def toggle(device)
    if is_on_off_device(device)
      toggle_on_off_device(device)
    end
  end

private
  def toggle_on_off_device(device)
    device.on = false
    pin = get_pin(device)
    current_value = get_gpio_value(pin)
    if current_value.present? && ON_OFF_DEVICE.values.include?(current_value.to_i)
      new_value = ON_OFF_DEVICE[:off]
      if current_value.to_i == ON_OFF_DEVICE[:off]
        new_value = ON_OFF_DEVICE[:on]
      end
      data = update_gpio(pin, new_value)
      value = data['value']
      if value.present? && value.to_i == ON_OFF_DEVICE[:on]
        device.on = true
      end
    end
  end

  def toggle_pwm_device(device)
  end

  def get_pin(device)
    device.port.to_i if device.port.present?
  end

  def is_on_off_device(device)
    device.is_a?(OnOffDevice)
  end

  def update_gpio(pin, value)
    data = {pin: pin, value: value}.to_json
    http_post(data)
  end

  def get_gpio_value(pin)
    read_gpio(pin)['value']
  end

  def read_gpio(pin)
    data = {pin: pin}.to_json
    http_post(data)
  end

  def http_post(data)
    req = Net::HTTP::Post.new('/', initheader = {'Content-Type' =>'application/json'})
    req.body = data
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    JSON.parse(response.body)
  end
end
