# frozen_string_literal: true

RSpec.describe Legion::Extensions::CognitiveBoundary::Runners::CognitiveBoundary do
  let(:client) { Legion::Extensions::CognitiveBoundary::Client.new }

  describe '#create_boundary' do
    it 'returns success with boundary hash' do
      result = client.create_boundary(name: 'test')
      expect(result[:success]).to be true
      expect(result[:boundary]).to include(:id, :name, :permeability, :integrity)
    end
  end

  describe '#open_boundary' do
    it 'increases permeability' do
      b = client.create_boundary(name: 'test')
      bid = b[:boundary][:id]
      result = client.open_boundary(boundary_id: bid)
      expect(result[:success]).to be true
      expect(result[:boundary][:permeability]).to be > 0.5
    end

    it 'returns failure for unknown id' do
      result = client.open_boundary(boundary_id: 'fake')
      expect(result[:success]).to be false
    end
  end

  describe '#close_boundary' do
    it 'decreases permeability' do
      b = client.create_boundary(name: 'test')
      bid = b[:boundary][:id]
      result = client.close_boundary(boundary_id: bid)
      expect(result[:success]).to be true
      expect(result[:boundary][:permeability]).to be < 0.5
    end
  end

  describe '#violate_boundary' do
    it 'increments violations' do
      b = client.create_boundary(name: 'test')
      bid = b[:boundary][:id]
      result = client.violate_boundary(boundary_id: bid)
      expect(result[:success]).to be true
      expect(result[:boundary][:violations]).to eq(1)
    end
  end

  describe '#repair_boundary' do
    it 'decrements violations' do
      b = client.create_boundary(name: 'test')
      bid = b[:boundary][:id]
      client.violate_boundary(boundary_id: bid)
      result = client.repair_boundary(boundary_id: bid)
      expect(result[:success]).to be true
      expect(result[:boundary][:violations]).to eq(0)
    end
  end

  describe '#seal_boundary' do
    it 'sets permeability to 0' do
      b = client.create_boundary(name: 'test')
      bid = b[:boundary][:id]
      result = client.seal_boundary(boundary_id: bid)
      expect(result[:success]).to be true
      expect(result[:boundary][:permeability]).to eq(0.0)
    end
  end

  describe '#breached_boundaries' do
    it 'returns breached boundaries' do
      client.create_boundary(name: 'open', permeability: 0.9)
      result = client.breached_boundaries
      expect(result[:success]).to be true
      expect(result[:count]).to be >= 1
    end
  end

  describe '#boundaries_by_type' do
    it 'filters by type' do
      client.create_boundary(name: 'emo', boundary_type: :emotional)
      result = client.boundaries_by_type(boundary_type: :emotional)
      expect(result[:success]).to be true
      expect(result[:count]).to be >= 1
    end
  end

  describe '#overall_integrity' do
    it 'returns integrity score' do
      result = client.overall_integrity
      expect(result[:success]).to be true
      expect(result[:integrity]).to be_a(Numeric)
    end
  end

  describe '#overall_permeability' do
    it 'returns permeability score' do
      result = client.overall_permeability
      expect(result[:success]).to be true
      expect(result[:permeability]).to be_a(Numeric)
    end
  end

  describe '#boundary_report' do
    it 'returns a full report' do
      result = client.boundary_report
      expect(result[:success]).to be true
      expect(result[:report]).to include(:total_boundaries, :overall_integrity)
    end
  end
end
