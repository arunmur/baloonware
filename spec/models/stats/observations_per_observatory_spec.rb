require './models/stats'
require './models/measurement'
require 'rspec/its'

describe Stats::ObservationsPerObeservatory do
  subject {
    stat = described_class.new
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|10|AU")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|-5|US")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|20|AU")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|20|US")
    stat = stat.record(measurement)
    measurement = Measurement.from_recording("2010-01-01T00:00|10,5|20|FR")
    stat.record(measurement)
  }

  its(:value) { is_expected.to be_within(0.001).of(1.6667) }
  specify {
    expect { |b| subject.each(&b) }.to yield_successive_args(
      include("AU", 2),
      include("US", 2),
      include("FR", 1)
    )
  }

end

