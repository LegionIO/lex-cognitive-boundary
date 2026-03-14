# frozen_string_literal: true

require 'securerandom'

module Legion
  module Extensions
    module CognitiveBoundary
      module Helpers
        class Boundary
          include Constants

          attr_reader :id, :name, :boundary_type, :permeability, :violations,
                      :created_at

          def initialize(name:, boundary_type: :cognitive, permeability: DEFAULT_PERMEABILITY)
            @id           = SecureRandom.uuid
            @name         = name
            @boundary_type = boundary_type.to_sym
            @permeability = permeability.to_f.clamp(0.0, 1.0)
            @violations   = 0
            @created_at   = Time.now.utc
          end

          def integrity
            base = 1.0 - (@violations * 0.05)
            [base, 0.0].max.round(10)
          end

          def integrity_label
            match = INTEGRITY_LABELS.find { |range, _| range.cover?(integrity) }
            match ? match.last : :breached
          end

          def permeability_label
            match = PERMEABILITY_LABELS.find { |range, _| range.cover?(@permeability) }
            match ? match.last : :sealed
          end

          def breached?
            @permeability >= BREACH_THRESHOLD || integrity < 0.2
          end

          def open!(amount: PERMEABILITY_BOOST)
            @permeability = (@permeability + amount).clamp(0.0, 1.0).round(10)
            self
          end

          def close!(amount: PERMEABILITY_BOOST)
            @permeability = (@permeability - amount).clamp(0.0, 1.0).round(10)
            self
          end

          def violate!
            @violations += 1
            self
          end

          def repair!
            @violations = [(@violations - 1), 0].max
            self
          end

          def seal!
            @permeability = 0.0
            self
          end

          def to_h
            {
              id:                  @id,
              name:                @name,
              boundary_type:       @boundary_type,
              permeability:        @permeability,
              permeability_label:  permeability_label,
              integrity:           integrity,
              integrity_label:     integrity_label,
              breached:            breached?,
              violations:          @violations,
              created_at:          @created_at
            }
          end
        end
      end
    end
  end
end
