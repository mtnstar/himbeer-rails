require 'rails_helper'
require 'pry'

describe GpioServiceClient do

  before(:each) do
    GpioServiceClient.any_instance.stub(:http_post).and_return({'pin' => 1, 'value' => 0})
    @gsc = GpioServiceClient.new
  end

  describe "#toggle" do
    it "toggles devices on/off" do
      data = @gsc.toggle(1)
      expect(@gsc).to receive(:read_gpio).with(1)
      expect(@gsc).to receive(:update_gpio).with(1,1)
    end
  end
end
