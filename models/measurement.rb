require 'time'
require './models/unit'

class Measurement
  # @return [DateTime] the time of the measurement.
  attr_reader :time

  # @return [Array<Unit>] the location of the measurement in pairs.
  attr_reader :location

  # @return [Unit] the temperature measurement.
  attr_reader :temperature

  # @return [String] the country the measurement was taken in.
  attr_reader :country

  def initialize(time, location, temperature, country)
    @time = time
    @location = location
    @temperature = temperature
    @country = country
  end

  # @param [Measurement] the measurement from which we want to measure distance
  # @return [Unit] the distance between this and the provided measurement.
  def distance_between(measurement)
    measurement.location[0].class.new(
      Math.sqrt(((measurement.location[0].value - location[0].value) ** 2) + ((measurement.location[1].value - location[1].value) ** 2))
     )
  end
end
