# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveBoundary::Helpers::Boundary do
  subject(:boundary) { described_class.new(name: 'test_boundary') }

  describe '#initialize' do
    it 'assigns a UUID id' do
      expect(boundary.id).to match(/\A[0-9a-f-]{36}\z/)
    end

    it 'sets name' do
      expect(boundary.name).to eq('test_boundary')
    end

    it 'defaults to cognitive type' do
      expect(boundary.boundary_type).to eq(:cognitive)
    end

    it 'defaults permeability to DEFAULT_PERMEABILITY' do
      default = Legion::Extensions::CognitiveBoundary::Helpers::Constants::DEFAULT_PERMEABILITY
      expect(boundary.permeability).to eq(default)
    end

    it 'starts with 0 violations' do
      expect(boundary.violations).to eq(0)
    end

    it 'clamps permeability to 0..1' do
      high = described_class.new(name: 'high', permeability: 5.0)
      expect(high.permeability).to eq(1.0)

      low = described_class.new(name: 'low', permeability: -1.0)
      expect(low.permeability).to eq(0.0)
    end

    it 'converts boundary_type to symbol' do
      b = described_class.new(name: 'b', boundary_type: 'emotional')
      expect(b.boundary_type).to eq(:emotional)
    end
  end

  describe '#integrity' do
    it 'starts at 1.0 with no violations' do
      expect(boundary.integrity).to eq(1.0)
    end

    it 'decreases with violations' do
      5.times { boundary.violate! }
      expect(boundary.integrity).to eq(0.75)
    end

    it 'floors at 0.0' do
      25.times { boundary.violate! }
      expect(boundary.integrity).to eq(0.0)
    end
  end

  describe '#integrity_label' do
    it 'returns :intact for full integrity' do
      expect(boundary.integrity_label).to eq(:intact)
    end

    it 'returns :breached for very low integrity' do
      20.times { boundary.violate! }
      expect(boundary.integrity_label).to eq(:breached)
    end
  end

  describe '#permeability_label' do
    it 'returns a symbol' do
      expect(boundary.permeability_label).to be_a(Symbol)
    end

    it 'returns :sealed for 0.0 permeability' do
      boundary.seal!
      expect(boundary.permeability_label).to eq(:sealed)
    end
  end

  describe '#breached?' do
    it 'is false when healthy' do
      expect(boundary.breached?).to be false
    end

    it 'is true when permeability exceeds threshold' do
      b = described_class.new(name: 'open', permeability: 0.9)
      expect(b.breached?).to be true
    end

    it 'is true when integrity drops below 0.2' do
      17.times { boundary.violate! }
      expect(boundary.breached?).to be true
    end
  end

  describe '#open!' do
    it 'increases permeability' do
      original = boundary.permeability
      boundary.open!
      expect(boundary.permeability).to be > original
    end

    it 'clamps at 1.0' do
      b = described_class.new(name: 'high', permeability: 0.99)
      b.open!(amount: 0.5)
      expect(b.permeability).to eq(1.0)
    end

    it 'returns self for chaining' do
      expect(boundary.open!).to eq(boundary)
    end
  end

  describe '#close!' do
    it 'decreases permeability' do
      original = boundary.permeability
      boundary.close!
      expect(boundary.permeability).to be < original
    end

    it 'clamps at 0.0' do
      b = described_class.new(name: 'low', permeability: 0.01)
      b.close!(amount: 0.5)
      expect(b.permeability).to eq(0.0)
    end
  end

  describe '#violate!' do
    it 'increments violation count' do
      boundary.violate!
      expect(boundary.violations).to eq(1)
    end

    it 'returns self' do
      expect(boundary.violate!).to eq(boundary)
    end
  end

  describe '#repair!' do
    it 'decrements violation count' do
      3.times { boundary.violate! }
      boundary.repair!
      expect(boundary.violations).to eq(2)
    end

    it 'floors at 0' do
      boundary.repair!
      expect(boundary.violations).to eq(0)
    end
  end

  describe '#seal!' do
    it 'sets permeability to 0.0' do
      boundary.seal!
      expect(boundary.permeability).to eq(0.0)
    end
  end

  describe '#to_h' do
    it 'includes all fields' do
      hash = boundary.to_h
      expect(hash).to include(
        :id, :name, :boundary_type, :permeability, :permeability_label,
        :integrity, :integrity_label, :breached, :violations, :created_at
      )
    end
  end
end
