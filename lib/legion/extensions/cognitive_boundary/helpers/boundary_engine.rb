# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveBoundary
      module Helpers
        class BoundaryEngine
          include Constants

          def initialize
            @boundaries = {}
          end

          def create_boundary(name:, boundary_type: :cognitive,
                              permeability: DEFAULT_PERMEABILITY)
            prune_if_needed
            boundary = Boundary.new(
              name:          name,
              boundary_type: boundary_type,
              permeability:  permeability
            )
            @boundaries[boundary.id] = boundary
            boundary
          end

          def open_boundary(boundary_id:, amount: PERMEABILITY_BOOST)
            boundary = @boundaries[boundary_id]
            return nil unless boundary

            boundary.open!(amount: amount)
          end

          def close_boundary(boundary_id:, amount: PERMEABILITY_BOOST)
            boundary = @boundaries[boundary_id]
            return nil unless boundary

            boundary.close!(amount: amount)
          end

          def violate_boundary(boundary_id:)
            boundary = @boundaries[boundary_id]
            return nil unless boundary

            boundary.violate!
          end

          def repair_boundary(boundary_id:)
            boundary = @boundaries[boundary_id]
            return nil unless boundary

            boundary.repair!
          end

          def seal_boundary(boundary_id:)
            boundary = @boundaries[boundary_id]
            return nil unless boundary

            boundary.seal!
          end

          def breached_boundaries
            @boundaries.values.select(&:breached?)
          end

          def boundaries_by_type(boundary_type:)
            bt = boundary_type.to_sym
            @boundaries.values.select { |b| b.boundary_type == bt }
          end

          def most_violated(limit: 5)
            @boundaries.values.sort_by { |b| -b.violations }.first(limit)
          end

          def overall_integrity
            return 1.0 if @boundaries.empty?

            scores = @boundaries.values.map(&:integrity)
            (scores.sum / scores.size).round(10)
          end

          def overall_permeability
            return 0.5 if @boundaries.empty?

            perms = @boundaries.values.map(&:permeability)
            (perms.sum / perms.size).round(10)
          end

          def boundary_report
            {
              total_boundaries:     @boundaries.size,
              breached_count:       breached_boundaries.size,
              overall_integrity:    overall_integrity,
              overall_permeability: overall_permeability,
              most_violated:        most_violated(limit: 3).map(&:to_h)
            }
          end

          def to_h
            {
              total_boundaries:     @boundaries.size,
              breached_count:       breached_boundaries.size,
              overall_integrity:    overall_integrity,
              overall_permeability: overall_permeability
            }
          end

          private

          def prune_if_needed
            return if @boundaries.size < MAX_BOUNDARIES

            least_violated = @boundaries.values.min_by(&:violations)
            @boundaries.delete(least_violated.id) if least_violated
          end
        end
      end
    end
  end
end
