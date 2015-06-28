
module Stats
  class MaxTemp
    attr_reader :value
    def initialize(value=0.0)
      @value = value
    end

    def record(measurement)
      if measurement.temperature.value > @value
        MaxTemp.new(measurement.temperature.value)
      else
        self
      end
    end
  end

  class MinTemp
    attr_reader :value
    attr_reader :measurement
    def initialize(value=nil)
      @value = value
    end

    def record(measurement)
      if @value.nil? or measurement.temperature.value < @value
        MinTemp.new(measurement.temperature.value)
      else
        self
      end
    end
  end

  class MeanTemp
    def initialize(total_value=0.0, no_measurements=0.0)
      @total_value = total_value
      @no_measurements = no_measurements
    end

    def value
      @total_value / @no_measurements
    end

    def record(measurement)
      MeanTemp.new(@total_value + measurement.temperature.value, @no_measurements + 1)
    end
  end

  class ObservationsPerObeservatory
    def initialize(observatory_count=Hash.new(0))
      @observatory_count = observatory_count
    end

    def value
      @observatory_count.values.reduce(:+) / @observatory_count.keys.size
    end

    def each
      @observatory_count.each do |observatory, count|
        yield(observatory, count)
      end
    end

    def record(measurement)
      ObservationsPerObeservatory.new(
        @observatory_count.merge({measurement.country.code => @observatory_count[measurement.country.code] + 1})
      )
    end
  end

  class TotalDistanceTravelled
    def initialize(distance=0, last_point=nil)
      @distance = distance
      @last_point = last_point
    end

    def value
      @distance
    end

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
