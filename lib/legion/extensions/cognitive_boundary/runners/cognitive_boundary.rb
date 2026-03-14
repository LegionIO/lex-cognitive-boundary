# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveBoundary
      module Runners
        module CognitiveBoundary
          include Helpers::Constants

          include Legion::Extensions::Helpers::Lex if defined?(Legion::Extensions::Helpers::Lex)

          def create_boundary(name:, engine: nil, boundary_type: :cognitive,
                              permeability: DEFAULT_PERMEABILITY, **)
            eng = engine || default_engine
            boundary = eng.create_boundary(name: name, boundary_type: boundary_type,
                                           permeability: permeability)
            { success: true, boundary: boundary.to_h }
          end

          def open_boundary(boundary_id:, engine: nil, amount: PERMEABILITY_BOOST, **)
            eng = engine || default_engine
            result = eng.open_boundary(boundary_id: boundary_id, amount: amount)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def close_boundary(boundary_id:, engine: nil, amount: PERMEABILITY_BOOST, **)
            eng = engine || default_engine
            result = eng.close_boundary(boundary_id: boundary_id, amount: amount)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def violate_boundary(boundary_id:, engine: nil, **)
            eng = engine || default_engine
            result = eng.violate_boundary(boundary_id: boundary_id)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def repair_boundary(boundary_id:, engine: nil, **)
            eng = engine || default_engine
            result = eng.repair_boundary(boundary_id: boundary_id)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def seal_boundary(boundary_id:, engine: nil, **)
            eng = engine || default_engine
            result = eng.seal_boundary(boundary_id: boundary_id)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def breached_boundaries(engine: nil, **)
            eng = engine || default_engine
            breached = eng.breached_boundaries.map(&:to_h)
            { success: true, breached: breached, count: breached.size }
          end

          def boundaries_by_type(boundary_type:, engine: nil, **)
            eng = engine || default_engine
            boundaries = eng.boundaries_by_type(boundary_type: boundary_type).map(&:to_h)
            { success: true, boundaries: boundaries, count: boundaries.size }
          end

          def overall_integrity(engine: nil, **)
            eng = engine || default_engine
            { success: true, integrity: eng.overall_integrity }
          end

          def overall_permeability(engine: nil, **)
            eng = engine || default_engine
            { success: true, permeability: eng.overall_permeability }
          end

          def boundary_report(engine: nil, **)
            eng = engine || default_engine
            { success: true, report: eng.boundary_report }
          end

          private

          def default_engine
            @default_engine ||= Helpers::BoundaryEngine.new
          end
        end
      end
    end
  end
end
