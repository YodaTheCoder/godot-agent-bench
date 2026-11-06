# Status Effects System

This system implements timed status effects including Poison and Slow that can be applied to any node with a Health component.

## Files Created:
- `scripts/effects/status_effect.gd` - Base resource class for status effects
- `scripts/effects/poison.gd` - Poison effect that damages over time
- `scripts/effects/slow.gd` - Slow effect that reduces movement speed
- `scripts/components/status_effects.gd` - Component that manages active status effects

## Integration:
- Player now has a StatusEffects component and uses effective_speed() for movement