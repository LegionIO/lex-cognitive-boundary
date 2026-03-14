# lex-cognitive-boundary

**Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Models permeable cognitive boundaries with integrity tracking and breach detection. Boundaries represent the membranes between cognitive domains (cognitive, emotional, social, informational, temporal, authority, privacy). Each boundary has a permeability score and integrity score; violations degrade both.

## Gem Info

- **Gem name**: `lex-cognitive-boundary`
- **Version**: `0.1.0`
- **Module**: `Legion::Extensions::CognitiveBoundary`
- **Ruby**: `>= 3.4`
- **License**: MIT

## File Structure

```
lib/legion/extensions/cognitive_boundary/
  cognitive_boundary.rb
  version.rb
  client.rb
  helpers/
    constants.rb
    boundary.rb
    boundary_engine.rb
  runners/
    cognitive_boundary.rb
```

## Key Constants

From `helpers/constants.rb`:

- `BOUNDARY_TYPES` — `%i[cognitive emotional social informational temporal authority privacy]`
- `MAX_BOUNDARIES` = `100`, `MAX_VIOLATIONS` = `500`
- `DEFAULT_PERMEABILITY` = `0.5`, `PERMEABILITY_BOOST` = `0.05`, `PERMEABILITY_DECAY` = `0.03`
- `BREACH_THRESHOLD` = `0.8` (permeability >= this = breached boundary)
- `PERMEABILITY_LABELS` — `0.8+` = `:open`, `0.6` = `:permeable`, `0.4` = `:selective`, `0.2` = `:guarded`, below = `:sealed`
- `INTEGRITY_LABELS` — `0.8+` = `:intact`, `0.6` = `:stable`, `0.4` = `:stressed`, `0.2` = `:compromised`, below = `:breached`

## Runners

All methods in `Runners::CognitiveBoundary`:

- `create_boundary(name:, boundary_type: :cognitive, permeability: DEFAULT_PERMEABILITY)` — creates a new named boundary
- `open_boundary(boundary_id:, amount: PERMEABILITY_BOOST)` — increases permeability
- `close_boundary(boundary_id:, amount: PERMEABILITY_BOOST)` — decreases permeability
- `violate_boundary(boundary_id:)` — records a violation; degrades integrity
- `repair_boundary(boundary_id:)` — recovers integrity
- `seal_boundary(boundary_id:)` — sets permeability to minimum (sealed state)
- `breached_boundaries` — returns all boundaries where permeability >= `BREACH_THRESHOLD`
- `boundaries_by_type(boundary_type:)` — filters by type
- `overall_integrity` — average integrity across all boundaries
- `overall_permeability` — average permeability across all boundaries
- `boundary_report` — full report with all boundaries and aggregate metrics

## Helpers

- `BoundaryEngine` — manages boundaries and violation log. `overall_integrity` and `overall_permeability` are arithmetic means.
- `Boundary` — named boundary with `permeability`, `integrity`, `boundary_type`, `violation_count`. Methods: `open!`, `close!`, `violate!`, `repair!`, `seal!`, `breached?`.

## Integration Points

- `lex-privatecore` enforces privacy boundaries; this extension models them as permeable objects with integrity degradation, enabling upstream callers to monitor boundary health.
- `lex-consent` manages authority and autonomy boundaries — the consent tier maps naturally to boundary permeability (higher consent = more open boundary).
- `lex-tick` can check `breached_boundaries` in safety phases to detect when cognitive or emotional boundaries have been overwhelmed.

## Development Notes

- `Boundary` names are stored as-is (not coerced to symbols). Callers should use consistent naming conventions.
- `violate_boundary` decrements integrity; `repair_boundary` recovers it. Neither crosses zero (clamped).
- `BREACH_THRESHOLD = 0.8` for permeability, not integrity — a boundary is breached when it is too open, not when integrity is too low. These are separate dimensions.
- `MAX_VIOLATIONS = 500` is a history cap on the violation log, not a per-boundary limit.
