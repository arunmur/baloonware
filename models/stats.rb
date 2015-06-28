
# Represents all the possible stat collection algorithms.
module Stats
  # Collects the MaxTemp stats
  class MaxTemp
    # @return [Float] the maximum temperature
    attr_reader :value

    # @param [Float] value the current maximum value
    def initialize(value=0.0)
      @value = value
    end

    # @param [Measurement] measurement the measurement from which to collect MaxTemp
    def record(measurement)
      if measurement.temperature.value > @value
        MaxTemp.new(measurement.temperature.value)
      else
        self
      end
    end
  end

  # Collects the MinTemp stats
  class MinTemp
    # @return [Float] the minimum temperature
    attr_reader :value
    #
    # @param [Float] value the current minimum value
    def initialize(value=nil)
      @value = value
    end

    # @param [Measurement] measurement the measurement from which to collect MinTemp
    def record(measurement)
      if @value.nil? or measurement.temperature.value < @value
        MinTemp.new(measurement.temperature.value)
      else
        self
      end
    end
  end

  # Collects the mean/avg temperature stats
  class MeanTemp
    # @param [Float] total_value the sum total of all the temperatures collected so far.
    # @param [Float] no_measurements the number of measurements from which the total was collected.
    def initialize(total_value=0.0, no_measurements=0.0)
      @total_value = total_value
      @no_measurements = no_measurements
    end

    # @return [Float] the average/mean temperature at this point.
    def value
      @total_value.to_f / @no_measurements
    end

    # @param [Measurement] measurement the measurement to record from.
    # @return [MeanTemp] the stat after recording from the measurement.
    def record(measurement)
      MeanTemp.new(@total_value + measurement.temperature.value, @no_measurements + 1)
    end
  end

  # Collects the number of observations per observatory.
  class ObservationsPerObeservatory
    # @param [Hash<String, Int>] observatory_count the hash containing the counter per observatory.
    def initialize(observatory_count=Hash.new(0))
      @observatory_count = observatory_count
    end

    # @return [Float] the average number measurements per observatory
    def value
      @observatory_count.values.reduce(:+).to_f / @observatory_count.keys.size
    end

    # @yeilds [String, Int] the number of measurements recieved per observatory
    def each
      @observatory_count.each do |observatory, count|
        yield(observatory, count)
      end
    end

    # @param [Measurement] measurement the measurement to record
    # @return [ObservationsPerObeservatory] the stat after observation.
    def record(measurement)
      ObservationsPerObeservatory.new(
        @observatory_count.merge({measurement.country.code => @observatory_count[measurement.country.code] + 1})
      )
    end
  end

  # Collects the total distance travelled
  class TotalDistanceTravelled
    # @param [Float] distance the total distance travelled
    # @param [Measurement] last_point the last measurement from which to measure distance.
    def initialize(distance=0, last_point=nil)
      @distance = distance
      @last_point = last_point
    end

    # @return [Float] the distance at this point in time.
    def value
      @distance
    end

    # @param [Measurement] measurement the measurement to be recorded.
    # @return [TotalDistanceTravelled] the stat after recording measurement
    def record(measurement)
      #Ignore jitters or late date.
      if @last_point.nil?
        TotalDistanceTravelled.new(0, measurement)
      elsif measurement.time > @last_point.time
        TotalDistanceTravelled.new(@distance + @last_point.distance_between(measurement).value, measurement)
      else
        self
      end
    end
  end
end
