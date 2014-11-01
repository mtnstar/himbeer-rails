class Device < ActiveRecord::Base
  self.inheritance_column = :device
  validates :port, uniqueness: true

  attr_accessor :on
end
