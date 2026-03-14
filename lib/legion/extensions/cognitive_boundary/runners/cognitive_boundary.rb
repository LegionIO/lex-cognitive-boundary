# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveBoundary
      module Runners
        module CognitiveBoundary
          include Helpers::Constants

          if defined?(Legion::Extensions::Helpers::Lex)
            include Legion::Extensions::Helpers::Lex
          end

          def create_boundary(engine: nil, name:, boundary_type: :cognitive,
                              permeability: DEFAULT_PERMEABILITY, **)
            eng = engine || default_engine
            boundary = eng.create_boundary(name: name, boundary_type: boundary_type,
                                           permeability: permeability)
            { success: true, boundary: boundary.to_h }
          end

          def open_boundary(engine: nil, boundary_id:, amount: PERMEABILITY_BOOST, **)
            eng = engine || default_engine
            result = eng.open_boundary(boundary_id: boundary_id, amount: amount)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def close_boundary(engine: nil, boundary_id:, amount: PERMEABILITY_BOOST, **)
            eng = engine || default_engine
            result = eng.close_boundary(boundary_id: boundary_id, amount: amount)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def violate_boundary(engine: nil, boundary_id:, **)
            eng = engine || default_engine
            result = eng.violate_boundary(boundary_id: boundary_id)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def repair_boundary(engine: nil, boundary_id:, **)
            eng = engine || default_engine
            result = eng.repair_boundary(boundary_id: boundary_id)
            return { success: false, error: 'boundary not found' } unless result

            { success: true, boundary: result.to_h }
          end

          def seal_boundary(engine: nil, boundary_id:, **)
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

          def boundaries_by_type(engine: nil, boundary_type:, **)
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
