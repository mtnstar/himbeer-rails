require 'json'
require 'yaml'
require 'net/http'

class GpioServiceClient

  ON_OFF_DEVICE = {on: 0, off: 1}
  PWM_DEVICE = {on: 50, off: 0}
  TYPE_PWM = 'pwm'

  def initialize
    config = YAML.load_file('config/gpio_service_client.yaml')[Rails.env]
    @host = config["host"]
    @port = config["port"]
  end

  def toggle(device)
    if is_on_off_device(device)
      toggle_on_off_device(device)
    elsif is_pwm_device(device)
      toggle_pwm_device(device)
    end
  end

  def set_value(device, value)
    if is_pwm_device(device)
      if (1..100).include?(value)
        pin = get_pin(device)
        update_gpio(pin, value, TYPE_PWM)
      end
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
      data = update_gpio(pin, new_value, nil)
      value = data['value']
      if value.present? && value.to_i == ON_OFF_DEVICE[:on]
        device.on = true
      end
    end
  end

  def toggle_pwm_device(device)
    device.on = false
    pin = get_pin(device)
    current_value = get_gpio_value(pin)
    if current_value.present?
      new_value = PWM_DEVICE[:off]
      if current_value.to_i == PWM_DEVICE[:off]
        new_value = percent_to_pwm_value(PWM_DEVICE[:on])
      end
      data = update_gpio(pin, new_value, 'pwm')
      value = data['value']
      if value.present? && (value.to_i > PWM_DEVICE[:off])
        device.on = true
      end
    end
  end

  def get_pin(device)
    device.port.to_i if device.port.present?
  end

  def is_on_off_device(device)
    device.is_a?(OnOffDevice)
  end

  def is_pwm_device(device)
    device.is_a?(PwmDevice)
  end

  def update_gpio(pin, value, type)
    data = {pin: pin, value: value, type: type}.to_json
    http_post(data)
  end

  def get_gpio_value(pin)
    read_gpio(pin)['value']
  end

  def percent_to_pwm_value(percent)
    return 0 if percent == 0
    value = 1024 / (100 / percent)
    value.to_i
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
