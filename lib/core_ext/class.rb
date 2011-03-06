class Class
  def dynamic_field(name, static_value)
    if block_given?
      define_method name, Proc.new
    elsif static_value
      define_method(name) { static_value }
    else
      raise ArgumentError, "must be passed either a static value or a block"
    end
  end
end

