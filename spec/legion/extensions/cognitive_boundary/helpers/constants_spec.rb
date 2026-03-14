# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveBoundary::Helpers::Constants do
  let(:klass) { Class.new { include Legion::Extensions::CognitiveBoundary::Helpers::Constants } }

  describe 'DEFAULT_PERMEABILITY' do
    it 'is a float between 0 and 1' do
      expect(klass::DEFAULT_PERMEABILITY).to be_a(Float)
      expect(klass::DEFAULT_PERMEABILITY).to be_between(0.0, 1.0)
    end
  end

  describe 'PERMEABILITY_BOOST' do
    it 'is a small positive float' do
      expect(klass::PERMEABILITY_BOOST).to be_a(Float)
      expect(klass::PERMEABILITY_BOOST).to be > 0
      expect(klass::PERMEABILITY_BOOST).to be < 0.5
    end
  end

  describe 'BREACH_THRESHOLD' do
    it 'is a float between 0 and 1' do
      expect(klass::BREACH_THRESHOLD).to be_a(Float)
      expect(klass::BREACH_THRESHOLD).to be_between(0.0, 1.0)
    end
  end

  describe 'PERMEABILITY_LABELS' do
    it 'is a frozen hash' do
      expect(klass::PERMEABILITY_LABELS).to be_a(Hash).and be_frozen
    end

    it 'covers the full 0..1 range' do
      labels = klass::PERMEABILITY_LABELS
      [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0].each do |val|
        match = labels.find { |range, _| range.cover?(val) }
        expect(match).not_to be_nil, "no label for #{val}"
      end
    end
  end

  describe 'INTEGRITY_LABELS' do
    it 'is a frozen hash' do
      expect(klass::INTEGRITY_LABELS).to be_a(Hash).and be_frozen
    end
  end

  describe 'BOUNDARY_TYPES' do
    it 'is a frozen array of symbols' do
      expect(klass::BOUNDARY_TYPES).to be_a(Array).and be_frozen
      expect(klass::BOUNDARY_TYPES).to all(be_a(Symbol))
    end

    it 'includes cognitive and emotional' do
      expect(klass::BOUNDARY_TYPES).to include(:cognitive, :emotional)
    end
  end

  describe 'MAX_BOUNDARIES' do
    it 'is a positive integer' do
      expect(klass::MAX_BOUNDARIES).to be_a(Integer)
      expect(klass::MAX_BOUNDARIES).to be > 0
    end
  end
end
