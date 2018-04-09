class NumberDecimal
  attr_reader :value

  def initialize(v, n = nil)
    @value = case v
             when BigDecimal
               v
             when NumberDecimal
               v.value
             else
               if n
                 BigDecimal(v, n)
               else
                 BigDecimal(v)
               end
             end
  end

  def self.to_big_decimal(object)
    case object 
    when NumberDecimal
      object.value
    when BigDecimal
      object
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
    BSON::Decimal128.new(@value)
  end

  def to_s
    @value.to_s
  end

  def to_big_decimal
    @value
  end

  class << self
    def demongoize(object)
      NumberDecimal.new(object&.to_big_decimal)
    end

    def mongoize(object)
      NumberDecimal.new(object.to_s).mongoize
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
