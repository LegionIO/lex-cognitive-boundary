# lex-cognitive-boundary

Cognitive boundary enforcement for LegionIO. Models permeable cognitive boundaries with integrity tracking and breach detection.

## What It Does

Cognitive boundaries are the membranes between domains of thought, feeling, and authority. This extension gives each boundary a permeability score (how open it is to external influence) and an integrity score (how intact the membrane is). Violations degrade integrity; deliberate repair restores it. Breached boundaries (too open) are flagged for attention.

Boundary types include cognitive, emotional, social, informational, temporal, authority, and privacy — mapping to the real boundaries an agent must maintain between its own processing and external influence.

## Usage

```ruby
client = Legion::Extensions::CognitiveBoundary::Client.new

boundary = client.create_boundary(
  name: 'emotional_regulation',
  boundary_type: :emotional,
  permeability: 0.4
)

client.violate_boundary(boundary_id: boundary[:boundary][:id])
client.repair_boundary(boundary_id: boundary[:boundary][:id])

client.breached_boundaries
client.boundary_report
```

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
