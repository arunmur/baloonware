module Unit
  class Celcius
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def to_celcius
      self
    end

    def to_fahrenheit
      Fahrenheit.new(@value * 9.0/5 + 32)
    end
  end

  class Fahrenheit
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def to_fahrenheit
      self
    end

    def to_celcius
      Celcius.new((@value - 32) * 5.0/9)
    end
  end
end
