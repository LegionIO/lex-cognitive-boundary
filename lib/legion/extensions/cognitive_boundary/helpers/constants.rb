# frozen_string_literal: true

module Legion
  module Extensions
    module CognitiveBoundary
      module Helpers
        module Constants
          MAX_BOUNDARIES = 100
          MAX_VIOLATIONS = 500

          DEFAULT_PERMEABILITY = 0.5
          PERMEABILITY_BOOST = 0.05
          PERMEABILITY_DECAY = 0.03
          BREACH_THRESHOLD = 0.8

          PERMEABILITY_LABELS = {
            (0.8..)     => :open,
            (0.6...0.8) => :permeable,
            (0.4...0.6) => :selective,
            (0.2...0.4) => :guarded,
            (..0.2)     => :sealed
          }.freeze

          INTEGRITY_LABELS = {
            (0.8..)     => :intact,
            (0.6...0.8) => :stable,
            (0.4...0.6) => :stressed,
            (0.2...0.4) => :compromised,
            (..0.2)     => :breached
          }.freeze

          BOUNDARY_TYPES = %i[
            cognitive emotional social informational
            temporal authority privacy
          ].freeze
        end
      end
    end
  end
end
