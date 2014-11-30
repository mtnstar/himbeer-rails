require 'rails_helper'
require 'pry'

describe GpioServiceClient do

  before(:each) do
    @on_off_device = mock_model("OnOffDevice", port: '42')
    @pwm_device = mock_model("PwmDevice")
    @gsc = GpioServiceClient.new
  end

  describe "#toggle" do
    describe "OnOffDevice" do
      it "should turn device on if it was off" do
        expect(@gsc).to receive(:read_gpio).and_return({'pin' => '42', 'value' => '1'})
        expect(@gsc).to receive(:update_gpio).with(42, 0)
          .and_return({'pin' => '42', 'value' => '0'})
        expect(@on_off_device).to receive(:on=).with(false)
        expect(@on_off_device).to receive(:on=).with(true)
        @gsc.toggle(@on_off_device)
      end

      it "should turn device off if it was on" do
        expect(@gsc).to receive(:read_gpio).and_return({'pin' => '42', 'value' => '0'})
        expect(@gsc).to receive(:update_gpio).with(42, 1)
          .and_return({'pin' => 42, 'value' => 1})
        expect(@on_off_device).to receive(:on=).with(false)
        @gsc.toggle(@on_off_device)
      end
    end
  end

  describe "#is_on_off_device" do
    it "return true if OnOffDevice" do
      result = @gsc.send(:is_on_off_device, @on_off_device)
      expect(result).to be(true)
    end

    it "return false if PwmDevice" do
      result = @gsc.send(:is_on_off_device, @pwm_device)
      expect(result).to be(false)
    end
  end

end
