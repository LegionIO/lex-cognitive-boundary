# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveBoundary::Helpers::BoundaryEngine do
  subject(:engine) { described_class.new }

  let(:boundary) { engine.create_boundary(name: 'test') }

  describe '#create_boundary' do
    it 'returns a Boundary' do
      expect(boundary).to be_a(Legion::Extensions::CognitiveBoundary::Helpers::Boundary)
    end

    it 'stores the boundary internally' do
      boundary
      expect(engine.to_h[:total_boundaries]).to eq(1)
    end

    it 'accepts type and permeability' do
      b = engine.create_boundary(name: 'custom', boundary_type: :emotional, permeability: 0.8)
      expect(b.boundary_type).to eq(:emotional)
      expect(b.permeability).to eq(0.8)
    end
  end

  describe '#open_boundary' do
    it 'increases boundary permeability' do
      original = boundary.permeability
      engine.open_boundary(boundary_id: boundary.id)
      expect(boundary.permeability).to be > original
    end

    it 'returns nil for unknown id' do
      expect(engine.open_boundary(boundary_id: 'fake')).to be_nil
    end
  end

  describe '#close_boundary' do
    it 'decreases boundary permeability' do
      original = boundary.permeability
      engine.close_boundary(boundary_id: boundary.id)
      expect(boundary.permeability).to be < original
    end

    it 'returns nil for unknown id' do
      expect(engine.close_boundary(boundary_id: 'fake')).to be_nil
    end
  end

  describe '#violate_boundary' do
    it 'increments violations' do
      engine.violate_boundary(boundary_id: boundary.id)
      expect(boundary.violations).to eq(1)
    end

    it 'returns nil for unknown id' do
      expect(engine.violate_boundary(boundary_id: 'fake')).to be_nil
    end
  end

  describe '#repair_boundary' do
    it 'decrements violations' do
      2.times { engine.violate_boundary(boundary_id: boundary.id) }
      engine.repair_boundary(boundary_id: boundary.id)
      expect(boundary.violations).to eq(1)
    end
  end

  describe '#seal_boundary' do
    it 'sets permeability to 0' do
      engine.seal_boundary(boundary_id: boundary.id)
      expect(boundary.permeability).to eq(0.0)
    end
  end

  describe '#breached_boundaries' do
    it 'returns only breached boundaries' do
      b = engine.create_boundary(name: 'fragile', permeability: 0.9)
      expect(engine.breached_boundaries).to include(b)
      expect(engine.breached_boundaries).not_to include(boundary)
    end
  end

  describe '#boundaries_by_type' do
    it 'filters by type' do
      engine.create_boundary(name: 'emo', boundary_type: :emotional)
      result = engine.boundaries_by_type(boundary_type: :emotional)
      expect(result.size).to eq(1)
      expect(result.first.boundary_type).to eq(:emotional)
    end
  end

  describe '#most_violated' do
    it 'sorts by violations descending' do
      b1 = engine.create_boundary(name: 'b1')
      b2 = engine.create_boundary(name: 'b2')
      3.times { engine.violate_boundary(boundary_id: b1.id) }
      1.times { engine.violate_boundary(boundary_id: b2.id) }
      most = engine.most_violated(limit: 2)
      expect(most.first.id).to eq(b1.id)
    end
  end

  describe '#overall_integrity' do
    it 'returns 1.0 with no boundaries' do
      fresh = described_class.new
      expect(fresh.overall_integrity).to eq(1.0)
    end

    it 'averages across all boundaries' do
      b1 = engine.create_boundary(name: 'a')
      10.times { engine.violate_boundary(boundary_id: b1.id) }
      engine.create_boundary(name: 'b')
      expect(engine.overall_integrity).to be_between(0.0, 1.0)
    end
  end

  describe '#overall_permeability' do
    it 'returns 0.5 with no boundaries' do
      fresh = described_class.new
      expect(fresh.overall_permeability).to eq(0.5)
    end

    it 'averages permeability across boundaries' do
      engine.create_boundary(name: 'a', permeability: 0.2)
      engine.create_boundary(name: 'b', permeability: 0.8)
      expect(engine.overall_permeability).to eq(0.5)
    end
  end

  describe '#boundary_report' do
    it 'includes all report fields' do
      boundary
      report = engine.boundary_report
      expect(report).to include(
        :total_boundaries, :breached_count, :overall_integrity,
        :overall_permeability, :most_violated
      )
    end
  end

  describe '#to_h' do
    it 'includes summary fields' do
      hash = engine.to_h
      expect(hash).to include(
        :total_boundaries, :breached_count,
        :overall_integrity, :overall_permeability
      )
    end
  end

  describe 'pruning' do
    it 'prunes least violated when limit reached' do
      stub_const('Legion::Extensions::CognitiveBoundary::Helpers::Constants::MAX_BOUNDARIES', 3)
      eng = described_class.new
      b1 = eng.create_boundary(name: 'b1')
      b2 = eng.create_boundary(name: 'b2')
      eng.violate_boundary(boundary_id: b2.id)
      b3 = eng.create_boundary(name: 'b3')
      eng.violate_boundary(boundary_id: b3.id)
      eng.violate_boundary(boundary_id: b3.id)
      eng.create_boundary(name: 'b4')
      expect(eng.to_h[:total_boundaries]).to eq(3)
    end
  end
end
