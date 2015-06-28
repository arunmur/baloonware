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

  # @param [String] data_line the line received from baloon.
  # @return [Measurement] after parsing data.
  def self.from_recording(data_line)
    data = data_line.tr("\n","").split("|")
    country = Country.get(data[3])
    Measurement.new(
      DateTime.strptime(data[0], "%Y-%m-%dT%H:%M"),
      data[1].split(",").map { |v| country.new_distance_unit(v.to_f) },
      country.new_temperature_unit(data[2].to_f),
      country
    )
  end

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

  # @return [String] the measurement as stored/recieved.
  def as_recording
    [
      @time.strftime("%Y-%m-%dT%H:%M"), @location.map { |co_ord| "%.4f" % co_ord.value }.join(","),
      "%.4f" % @temperature.value, @country.code
    ].join("|")
  end

  # @return [String] a string representation of measurement.
  def to_s
    as_recording
  end

  # Represents a country
  class Country
    # @param [String] the code for the country
    attr_reader :code

    # @param [String] country that we want to get.
    # @return [Country] constructed based on known country configuration.
    def self.get(country)
      @@known_countries ||= {
        "AU" => Country.new("AU", "Celcius", "Kilometers"),
        "US" => Country.new("US", "Fahrenheit", "Miles"),
        "FR" => Country.new("FR", "Kelvin", "Meters"),
      }

      if @@known_countries.has_key?(country)
        @@known_countries[country]
      else
        Country.new(country, "Kelvin", "Kilometers")
      end
    end

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

    # @param [Float] distance as recieved
    # @return [Unit] the value of the distance in this country's units.
    def new_distance_unit(distance)
      case @distance_units
      when "Kilometers"
        Unit::Kilometers.new(distance)
      when "Miles"
        Unit::Miles.new(distance)
      when "Meters"
        Unit::Meters.new(distance)
      end
    end

    # @param [Float] distance as recieved
    # @return [Unit] the value of the distance in this country's units.
    def new_temperature_unit(temperature)
      case @temperature_units
      when "Celcius"
        Unit::Celcius.new(temperature)
      when "Fahrenheit"
        Unit::Fahrenheit.new(temperature)
      when "Kelvin"
        Unit::Kelvin.new(temperature)
      end
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
