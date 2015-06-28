# Contains all the units used in the system.
module Unit
  # Represents the Celcius temperature measurement. Can be used to convert to other temperature measurements.
  # @see Fahrenheit
  # @see Kelvin
  class Celcius
    # @return [Float] the value of the measurement.
    attr_reader :value

    # @param [String] value the value of the measurment.
    def initialize(value)
      @value = value.to_f
    end

    # @return [Celcius] the object after converting to celcius.
    def to_celcius
      self
    end

    # @return [Fahrenheit] the object after converting to fahrenheit.
    def to_fahrenheit
      Fahrenheit.new(@value * 9.0/5 + 32)
    end

    # @return [Kelvin] the object after converting to kelvin.
    def to_kelvin
      Kelvin.new(@value + 273.15)
    end

    # @return [String] the string representation of the measurement.
    def to_s
      "#{value} C"
    end
  end

  # Represents the Fahrenheit temperature measurement. Can be used to convert to other temperature measurements.
  # @see Celcius
  # @see Kelvin
  class Fahrenheit
    # @return [Float] the value of the measurement.
    attr_reader :value

    # @param [String] value the value of the measurment.
    def initialize(value)
      @value = value.to_f
    end

    # @return [Fahrenheit] the object after converting to fahrenheit.
    def to_fahrenheit
      self
    end

    # @return [Celcius] the object after converting to celcius.
    def to_celcius
      Celcius.new((@value - 32) * 5.0/9)
    end

    # @return [Kelvin] the object after converting to kelvin.
    def to_kelvin
      to_celcius.to_kelvin
    end

    # @return [String] the string representation of the measurement.
    def to_s
      "#{value} F"
    end
  end

  # Represents the Kelvin temperature measurement. Can be used to convert to other temperature measurements.
  # @see Celcius
  # @see Fahrenheit
  class Kelvin
    # @return [Float] the value of the measurement.
    attr_reader :value

    # @param [String] value the value of the measurment.
    def initialize(value)
      @value = value.to_f
    end

    # @return [Fahrenheit] the object after converting to fahrenheit.
    def to_fahrenheit
      to_celcius.to_fahrenheit
    end

    # @return [Celcius] the object after converting to celcius.
    def to_celcius
      Celcius.new(@value - 273.15)
    end

    # @return [Kelvin] the object after converting to kelvin.
    def to_kelvin
      self
    end

    # @return [String] the string representation of the measurement.
    def to_s
      "#{value} K"
    end
  end
end
