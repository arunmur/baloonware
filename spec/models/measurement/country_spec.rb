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

  describe '#new_distance_unit' do
    subject { country.new_distance_unit(10) }
    it { is_expected.to be_a Unit::Kilometers }
    it { is_expected.to have_attributes(value: 10) }
  end

  describe '#new_temperature_unit' do
    subject { country.new_temperature_unit(10) }
    it { is_expected.to be_a Unit::Celcius }
    it { is_expected.to have_attributes(value: 10) }
  end

  describe '#for' do
    context 'AU' do
      let(:country) { described_class.get("AU") }
      subject { country }
      it { is_expected.to be_a Measurement::Country }

      describe '#localized_temperature' do
        let(:measurement) { Unit::Celcius.new(10) }
        subject { country.localized_temperature(measurement) }
        it { is_expected.to be_a Unit::Celcius }
      end

      describe '#localized_temperature' do
        let(:measurement) { Unit::Kilometers.new(10) }
        subject { country.localized_distance(measurement) }
        it { is_expected.to be_a Unit::Kilometers }
      end
    end

    context 'US' do
      let(:country) { described_class.get("US") }
      subject { country }
      it { is_expected.to be_a Measurement::Country }

      describe '#localized_temperature' do
        let(:measurement) { Unit::Celcius.new(10) }
        subject { country.localized_temperature(measurement) }
        it { is_expected.to be_a Unit::Fahrenheit }
      end

      describe '#localized_distance' do
        let(:measurement) { Unit::Kilometers.new(10) }
        subject { country.localized_distance(measurement) }
        it { is_expected.to be_a Unit::Miles }
      end
    end

    context 'FR' do
      let(:country) { described_class.get("FR") }
      subject { country }
      it { is_expected.to be_a Measurement::Country }

      describe '#localized_temperature' do
        let(:measurement) { Unit::Celcius.new(10) }
        subject { country.localized_temperature(measurement) }
        it { is_expected.to be_a Unit::Kelvin }
      end

      describe '#localized_distance' do
        let(:measurement) { Unit::Kilometers.new(10) }
        subject { country.localized_distance(measurement) }
        it { is_expected.to be_a Unit::Meters }
      end
    end

    context 'GB' do
      let(:country) { described_class.get("GB") }
      subject { country }
      it { is_expected.to be_a Measurement::Country }

      describe '#localized_temperature' do
        let(:measurement) { Unit::Celcius.new(10) }
        subject { country.localized_temperature(measurement) }
        it { is_expected.to be_a Unit::Kelvin }
      end

      describe '#localized_distance' do
        let(:measurement) { Unit::Kilometers.new(10) }
        subject { country.localized_distance(measurement) }
        it { is_expected.to be_a Unit::Kilometers }
      end
    end
  end
end
