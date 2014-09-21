class Device < ActiveRecord::Base
  self.inheritance_column = :device
  validates :gpio_port, uniqueness: true

  attr_accessor :on
end
