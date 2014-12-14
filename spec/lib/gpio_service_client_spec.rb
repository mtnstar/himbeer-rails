require 'rails_helper'

describe GpioServiceClient do

  before(:each) do
    @on_off_device = mock_model("OnOffDevice", port: '42')
    @pwm_device = mock_model("PwmDevice", port: '43')
    @gsc = GpioServiceClient.new
  end

  describe "#toggle" do
    describe "OnOffDevice" do
      it "should turn device on if it was off" do
        expect(@gsc).to receive(:read_gpio).and_return({'pin' => '42', 'value' => '1'})
        expect(@gsc).to receive(:update_gpio).with(42, 0, nil)
          .and_return({'pin' => '42', 'value' => '0'})
        expect(@on_off_device).to receive(:on=).with(false)
        expect(@on_off_device).to receive(:on=).with(true)
        @gsc.toggle(@on_off_device)
      end

      it "should turn device off if it was on" do
        expect(@gsc).to receive(:read_gpio).and_return({'pin' => '42', 'value' => '0'})
        expect(@gsc).to receive(:update_gpio).with(42, 1, nil)
          .and_return({'pin' => 42, 'value' => 1})
        expect(@on_off_device).to receive(:on=).with(false)
        @gsc.toggle(@on_off_device)
      end
    end

    describe "PwmDevice" do
      it "should turn device on if it was off" do
        expect(@gsc).to receive(:read_gpio).and_return({'pin' => '43', 'value' => '0'})
        expect(@gsc).to receive(:update_gpio).with(43, 511, 'pwm')
          .and_return({'pin' => '43', 'value' => '511'})
        expect(@pwm_device).to receive(:on=).with(false)
        expect(@pwm_device).to receive(:on=).with(true)
        @gsc.toggle(@pwm_device)
      end

      it "should turn device off if it was on" do
        expect(@gsc).to receive(:read_gpio).and_return({'pin' => '43', 'value' => '1023'})
        expect(@gsc).to receive(:update_gpio).with(43, 0, 'pwm')
          .and_return({'pin' => 43, 'value' => 0})
        expect(@pwm_device).to receive(:on=).with(false)
        @gsc.toggle(@pwm_device)
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

  describe "#is_pwm_device" do
    it "return true if PwmDevice" do
      result = @gsc.send(:is_pwm_device, @pwm_device)
      expect(result).to be(true)
    end

    it "return false if OnOffDevice" do
      result = @gsc.send(:is_pwm_device, @on_off_device)
      expect(result).to be(false)
    end
  end

  describe "#percent_to_pwm_value" do
    it "should return 511 if percent 50" do
      result = @gsc.send(:percent_to_pwm_value, 50)
      expect(result).to eq(511)
    end

    it "should return 1023 if percent 100" do
      result = @gsc.send(:percent_to_pwm_value, 100)
      expect(result).to eq(1023)
    end

    it "should return 10 if percent 1" do
      result = @gsc.send(:percent_to_pwm_value, 1)
      expect(result).to eq(10)
    end

    it "should return 0 if percent 0" do
      result = @gsc.send(:percent_to_pwm_value, 0)
      expect(result).to eq(0)
    end

    it "should return 869 if percent 85" do
      result = @gsc.send(:percent_to_pwm_value, 85)
      expect(result).to eq(869)
    end
  end

  describe "#set_value" do
    it "should not call gpio update if value null" do
      expect(@gsc).not_to receive(:get_pin)
      expect(@gsc).not_to receive(:update_gpio)
      result = @gsc.set_value(@pwm_device, nil)
      expect(result).to eq(nil)
    end

    it "should not call gpio update if value invalid" do
      expect(@gsc).not_to receive(:get_pin)
      expect(@gsc).not_to receive(:update_gpio)
      result = @gsc.set_value(@pwm_device, 'silly value')
      expect(result).to eq(nil)
    end

    it "should not call gpio update if not pwm device" do
      expect(@gsc).not_to receive(:get_pin)
      expect(@gsc).not_to receive(:update_gpio)
      result = @gsc.set_value(@on_off_device, 49)
      expect(result).to eq(nil)
    end

    it "should call gpio update with value 511 if 50 percent" do
      expect(@gsc).to receive(:update_gpio).with(43, 511, 'pwm')
      result = @gsc.set_value(@pwm_device, 50)
    end

    it "should call gpio update with value 10 if 1 percent" do
      expect(@gsc).to receive(:update_gpio).with(43, 10, 'pwm')
      result = @gsc.set_value(@pwm_device, 1)
    end

    it "should call gpio update with value 1023 if 100 percent" do
      expect(@gsc).to receive(:update_gpio).with(43, 1023, 'pwm')
      result = @gsc.set_value(@pwm_device, 100)
    end
  end
end
