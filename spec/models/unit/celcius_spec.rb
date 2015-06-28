require './models/unit'
require 'rspec/its'

describe Unit::Celcius do
  let(:unit) { described_class.new(10) }
  describe '#new' do
    subject { unit }
    its(:value) { is_expected.to eq(10) }
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
end
