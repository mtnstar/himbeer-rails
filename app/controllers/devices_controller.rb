class DevicesController < ApplicationController

  before_filter :set_default_response_format

  def on
    # switch device on
  end

  def off
    # switch device off
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

end
