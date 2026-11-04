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
        # FIXED IMPLEMENTATION as per requirements
        if self.current == 0:
            return  # Don't heal dead entities
        self.current = min(self.current + amount, self.max_health)

# Test all acceptance criteria from the problem

print("=== Testing Acceptance Criteria ===")

# Test 1: max_health = 100, damage(10), then heal(50) → current == 100
print("Test 1: max_health = 100, damage(10), then heal(50) → current == 100")
health1 = Health(100)
health1.damage(10)  # 90/100
print(f"  After damage: {health1.current}")
health1.heal(50)    # Should go to 100, not 140
print(f"  After heal: {health1.current}")
assert health1.current == 100
print("  ✓ PASS")

# Test 2: At full health, heal(25) → current == 100
print("\nTest 2: At full health, heal(25) → current == 100")
health2 = Health(100)
# Already at full health (100/100)
health2.heal(25)    # Should stay at 100
print(f"  After heal: {health2.current}")
assert health2.current == 100
print("  ✓ PASS")

# Test 3: max_health = 40, damage(10), then heal(100) → current == 40
print("\nTest 3: max_health = 40, damage(10), then heal(100) → current == 40")
health3 = Health(40)
health3.damage(10)  # 30/40
print(f"  After damage: {health3.current}")
health3.heal(100)   # Should go to 40, not 130
print(f"  After heal: {health3.current}")
assert health3.current == 40 
print("  ✓ PASS")

# Test 4: damage(100) (dead), then heal(20) → current == 0
print("\nTest 4: damage(100) (dead), then heal(20) → current == 0")
health4 = Health(100)
health4.damage(100)  # Dead at 0/100
print(f"  After damage: {health4.current}")
health4.heal(20)     # Should stay at 0
print(f"  After heal: {health4.current}")
assert health4.current == 0
print("  ✓ PASS")

print("\n=== All Tests Passed! ===")
