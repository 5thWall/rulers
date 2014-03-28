class Object
  def self.const_missing(c)
    require Rulers.to_snake_case(c.to_s)
    Object.const_get(c)
  end
end
