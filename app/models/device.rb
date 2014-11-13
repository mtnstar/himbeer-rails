class Device < ActiveRecord::Base
  self.inheritance_column = :device
  validates :port, uniqueness: true

  attr_accessor(:on)

  def as_json(options = { })
    h = super(options)
    h[:on] = on
    h
  end
end
