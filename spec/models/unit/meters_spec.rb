require './models/unit'
require 'rspec/its'

describe Unit::Meters do
  let(:unit) { described_class.new(16_000) }
  describe '#new' do
    subject { unit }
    its(:value) { is_expected.to eq(16_000) }
    its(:to_s) { is_expected.to eq("16000.0 m") }
  end

  describe '#to_km' do
    subject { unit.to_km }
    it { is_expected.to be_a Unit::Kilometers }
    its(:value) { is_expected.to be_within(0.01).of(16) }
  end

  describe '#to_miles' do
    subject { unit.to_miles }
    it { is_expected.to be_a Unit::Miles }
    its(:value) { is_expected.to eq(10) }
  end

  describe '#to_meters' do
    subject { unit.to_meters }
    it { is_expected.to be_a Unit::Meters }
    its(:value) { is_expected.to eq(16_000) }
  end
end
