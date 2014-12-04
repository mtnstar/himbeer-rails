class PwmDevice < Device
  attr_accessor :value

  def as_json(options = { })
    h = super(options)
    h[:value] = value
    h
  end

end
