#!/usr/bin/env python3

class Health:
    def __init__(self, max_health=100):
        self.max_health = max_health
        self.current = max_health
    
    def damage(self, amount):
        if self.current == 0:
            return
        self.current = max(self.current - amount, 0)
        if self.current == 0:
            print("Entity died!")
    
    def heal(self, amount):
        # CURRENT BROKEN IMPLEMENTATION
        self.current += amount
    
    def heal_fixed(self, amount):
        # FIXED IMPLEMENTATION
        if self.current == 0:
            return  # Don't heal dead entities
        self.current = min(self.current + amount, self.max_health)

# Test the bugs
print("=== Testing Current (Broken) Implementation ===")

# Bug 1: Overheal
health1 = Health(100)
health1.current = 90
print(f"Before heal (90/100): {health1.current}")
health1.heal(50)
print(f"After heal (should be 100, not 140): {health1.current}")

# Bug 2: Reviving dead entities
health2 = Health(100)
health2.damage(100)  # Kill it
print(f"Before heal (should be 0): {health2.current}")
health2.heal(20)  # Try to heal dead entity
print(f"After heal (should still be 0): {health2.current}")

print("\n=== Testing Fixed Implementation ===")

# Test fixed version with same scenarios
# Bug 1: Overheal fixed
health3 = Health(100)
health3.current = 90
print(f"Before heal (90/100): {health3.current}")
health3.heal_fixed(50)
print(f"After heal (should be 100): {health3.current}")

# Bug 2: Reviving dead entities fixed
health4 = Health(100)
health4.damage(100)  # Kill it
print(f"Before heal (should be 0): {health4.current}")
health4.heal_fixed(20)  # Try to heal dead entity
print(f"After heal (should still be 0): {health4.current}")

# Normal healing should work
health5 = Health(100)
health5.damage(50)  # Reduce to 50
print(f"Before heal (should be 50): {health5.current}")
health5.heal_fixed(20)  # Heal by 20
print(f"After heal (should be 70): {health5.current}")

# Different max health test
health6 = Health(40)
health6.damage(10)  # Reduce to 30
print(f"Before heal (should be 30): {health6.current}")
health6.heal_fixed(100)  # Heal by 100 (should cap at 40)
print(f"After heal (should be 40): {health6.current}")
