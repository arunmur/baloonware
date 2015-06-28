require './models/unit'
require 'rspec/its'

describe Unit::Kelvin do
  let(:unit) { described_class.new(283.15) }

  describe '#new' do
    subject { unit }
    its(:value) { is_expected.to eq(283.15) }
    its(:to_s) { is_expected.to eq("283.15 K") }
  end

  describe '#to_fahrenheit' do
    subject { unit.to_fahrenheit }
    it { is_expected.to be_a Unit::Fahrenheit }
    its(:value) { is_expected.to eq(50) }
  end

  describe '#to_celcius' do
    subject { unit.to_celcius }
    it { is_expected.to be_a Unit::Celcius }
    its(:value) { is_expected.to eq(10) }
  end

  describe '#to_kelvin' do
    subject { unit.to_kelvin }
    it { is_expected.to be_a Unit::Kelvin }
    its(:value) { is_expected.to eq(283.15) }
  end
end
