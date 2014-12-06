class DevicesController < ApplicationController

  before_filter :set_default_response_format, :init_gpio_service_client

  def toggle
    device = Device.find(params[:id])
    @gsc.toggle(device)
    respond_to do |format|
      format.json { render json: device }
    end
  end

  def set_value
    device = Device.find(params[:id])
    value = params[:value]
    if value.present?
      @gsc.set_value(device, value.to_i)
    end
    respond_to do |format|
      format.json { render json: device }
    end
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
