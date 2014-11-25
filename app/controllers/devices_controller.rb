class DevicesController < ApplicationController

  before_filter :set_default_response_format, :init_gpio_service_client

  def toggle
    device = Device.find(params[:id])
    data = @gsc.toggle(device.port)
    value = data["value"]
    if !value.nil? && value.to_i == 0
      device.on = true
    end
    respond_to do |format|
      format.json { render json: device }
    end
  end

  def setValue
    # set speed
  end

  def index
    @devices = Device.all
    respond_to do |format|
      format.json { render json: @devices }
    end
  end

  private
  def set_default_response_format
    request.format = :json
  end

  def init_gpio_service_client
    @gsc ||= GpioServiceClient.new
  end

end
