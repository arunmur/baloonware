require './models/measurement'
require 'rspec/its'

describe Measurement do
  let(:location) {
    [
      Unit::Kilometers.new(10),
      Unit::Kilometers.new(5)
    ]
  }
  let(:temperature) { Unit::Celcius.new(20) }
  let(:time) { DateTime.parse("2010-01-01T00:00:00") }
  let(:measurement) { described_class.new(time, location, temperature, "AU") }
  describe '#new' do
    subject { measurement }
    its('time.iso8601') { is_expected.to eq("2010-01-01T00:00:00+00:00") }
    its(:location) { is_expected.to contain_exactly(have_attributes(value: 10), have_attributes(value: 5)) }
    its(:temperature) { is_expected.to have_attributes(value: 20) }
    its(:country) { is_expected.to eq("AU") }
  end

  describe '#distance_between' do
    context 'when same' do
      subject { measurement.distance_between(measurement) }
      it { is_expected.to have_attributes(value: 0) }
    end

    context 'when on same x' do
      let(:measurement2) {
        location = [
          Unit::Kilometers.new(10),
          Unit::Kilometers.new(8)
        ]
        described_class.new(time, location, temperature, "AU")
      }
      subject { measurement.distance_between(measurement2) }
      it { is_expected.to have_attributes(value: 3) }
    end

    context 'when on same y' do
      let(:measurement2) {
        location = [
          Unit::Kilometers.new(12),
          Unit::Kilometers.new(5)
        ]
        described_class.new(time, location, temperature, "AU")
      }
      subject { measurement.distance_between(measurement2) }
      it { is_expected.to have_attributes(value: 2) }
    end

    context 'when different x and y' do
      let(:measurement2) {
        location = [
          Unit::Kilometers.new(12),
          Unit::Kilometers.new(7)
        ]
        described_class.new(time, location, temperature, "AU")
      }
      subject { measurement.distance_between(measurement2) }
      it { is_expected.to have_attributes(value: be_within(0.01).of(2.828)) }
    end
  end
end
