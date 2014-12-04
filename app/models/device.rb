class Device < ActiveRecord::Base
  self.inheritance_column = :device
  validates :port, uniqueness: true

  attr_accessor(:on)

  def as_json(options = { })
    h = super(options)
    h[:on] = on
    h[:type] = device
    h
  end

  def toggle
    # toggle on/off
  end
end
