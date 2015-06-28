require './models/stats'
require './models/measurement'
require 'rspec/its'

describe Stats::TotalDistanceTravelled do
  subject {
    stat = described_class.new
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|10|AU")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:02|10,7|-5|AU")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:01|10,6|20|AU")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:03|10,9|20|AU")
    stat.record(measurement)
  }

  its(:value) { is_expected.to be_within(0.001).of(4) }
end

