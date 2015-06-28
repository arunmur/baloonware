require './models/stats'
require './models/measurement'
require 'rspec/its'

describe Stats::MeanTemp do
  subject {
    stat = described_class.new
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|10|AU")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|-5|AU")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|20|AU")
    stat.record(measurement)
  }

  its(:value) { is_expected.to be_within(0.001).of(8.333) }
end

