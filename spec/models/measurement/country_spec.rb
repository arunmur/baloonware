require './models/measurement'
require 'rspec/its'

describe Measurement::Country do
  let(:country) { described_class.new("AU", "Celcius", "Kilometers") }
  describe '#new' do
    context 'when known units' do
      subject { country }
      its(:code) { is_expected.to eq("AU") }
    end

    context 'when unknwon units for temperature' do
      specify { expect{ described_class.new("AU", "c", "Kilometers") }.to raise_error("temperature unit c is unknown") }
    end

    context 'when unknwon units for distance' do
      specify { expect{ described_class.new("AU", "Celcius", "ks") }.to raise_error("distance unit ks is unknown") }
    end
  end

  describe '#localized_distance' do
    context 'when same as required' do
      let(:measurement) { Unit::Kilometers.new(10) }
      subject { country.localized_distance(measurement) }
      it { is_expected.to be_a Unit::Kilometers }
      it { is_expected.to have_attributes(value: 10) }
    end

    context 'when different from required' do
      let(:measurement) { Unit::Miles.new(10) }
      subject { country.localized_distance(measurement) }
      it { is_expected.to be_a Unit::Kilometers }
      it { is_expected.to have_attributes(value: 16) }
    end
  end

  describe '#localized_temperature' do
    context 'when same as required' do
      let(:measurement) { Unit::Celcius.new(10) }
      subject { country.localized_temperature(measurement) }
      it { is_expected.to be_a Unit::Celcius }
      it { is_expected.to have_attributes(value: 10) }
    end

    context 'when different from required' do
      let(:measurement) { Unit::Kelvin.new(268.15) }
      subject { country.localized_temperature(measurement) }
      it { is_expected.to be_a Unit::Celcius }
      it { is_expected.to have_attributes(value: -5) }
    end
  end
end
