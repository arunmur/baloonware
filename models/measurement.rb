require 'time'
require './models/unit'

# Represents a measurement recieved from baloon
class Measurement
  # @return [DateTime] the time of the measurement.
  attr_reader :time

  # @return [Array<Unit>] the location of the measurement in pairs.
  attr_reader :location

  # @return [Unit] the temperature measurement.
  attr_reader :temperature

  # @return [Country] the country the measurement was taken in.
  attr_reader :country

  # @param [DateTime] time the tie of the measurement.
  # @param [Array<Unit>] location the location of the measurement in pairs.
  # @param [Unit] temperature the temperature of the measurement.
  # @param [Country] country the country the measurement was taken in.
  def initialize(time, location, temperature, country)
    @time = time
    @country = country
    @location = location.map { |co_ord| @country.localized_distance(co_ord) }
    @temperature = @country.localized_temperature(temperature)
  end

  # Converts the measurements for a country into another.
  # @param [Country] the country to which we want to convert
  # @return [Measurement] after conversion.
  def for(country)
    Measurement.new(@time, @location, @temperature, country)
  end

  # @param [Measurement] the measurement from which we want to measure distance
  # @return [Unit] the distance between this and the provided measurement.
  def distance_between(measurement)
    measurement.location[0].class.new(
      Math.sqrt(((measurement.location[0].value - location[0].value) ** 2) + ((measurement.location[1].value - location[1].value) ** 2))
     )
  end

  # Represents a country
  class Country
    # @param [String] the code for the country
    attr_reader :code

    # @param [String] code the code for the country.
    # @param [String] temperature_units the units used for temperature (eg: Celcius, Farenheit, Kelvin)
    # @param [String] distance_units the units used for distance (eg: Kilometers, Miles, Meters)
    def initialize(code, temperature_units, distance_units)
      @code = code
      @distance_units = distance_units
      @temperature_units = temperature_units
      raise("temperature unit #{temperature_units} is unknown") if !["Celcius", "Fahrenheit", "Kelvin"].include?(@temperature_units)
      raise("distance unit #{distance_units} is unknown") if !["Kilometers", "Miles", "Meters"].include?(@distance_units)
    end

    # @param [Unit] distance an unit measurement for distance.
    # @return [Unit] the value of the distance in this country's units.
    def localized_distance(distance)
      case @distance_units
      when "Kilometers"
        distance.to_km
      when "Miles"
        distance.to_miles
      when "Meters"
        distance.to_meters
      end
    end

    # @param [Unit] temperature an unit measurement for temperauter.
    # @return [Unit] the value of the temperature in this country's units.
    def localized_temperature(temperature)
      case @temperature_units
      when "Celcius"
        temperature.to_celcius
      when "Fahrenheit"
        temperature.to_fahrenheit
      when "Kelvin"
        temperature.to_kelvin
      end
    end
  end
end
