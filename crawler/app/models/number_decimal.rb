class NumberDecimal
  attr_reader :value

  def initialize(v)
    @value = self.class.to_big_decimal(v)
  end

  def self.to_big_decimal(object)
    case object 
    when NumberDecimal
      object.value
    when BigDecimal
      object
    when Integer
      BigDecimal(object)
    when Float
      BigDecimal(object, 16)
    when BSON::Decimal128
      object.to_big_decimal
    else
      BigDecimal(object.to_s)
    end
  end

  def +(v)
    self.class.new(@value + self.class.to_big_decimal(v))
  end

  def -(v)
    self.class.new(@value - self.class.to_big_decimal(v))
  end

  def *(v)
    self.class.new(@value * self.class.to_big_decimal(v))
  end

  def /(v)
    self.class.new(@value / self.class.to_big_decimal(v))
  end

  def %(v)
    self.class.new(@value % self.class.to_big_decimal(v))
  end

  def +@
    self
  end

  def -@
    self.class.new(-@value)
  end

  def mongoize
    BSON::Decimal128.new(@value.round(16))
  end

  def to_s
    @value.to_s
  end

  def to_big_decimal
    @value
  end

  class << self
    def demongoize(object)
      NumberDecimal.new(NumberDecimal.to_big_decimal(object))
    end

    def mongoize(object)
      NumberDecimal.new(object).mongoize
    end

    def evolve(object)
      case object
      when NumberDecimal then object.mongoize
      when BigDecimal then NumberDecimal.new(object).mongoize
      else object
      end
    end
  end

end
