# Test script to verify Health.heal() fixes

# Create a health instance for testing
var health = Health.new()
health.max_health = 100
health.current = 90

print("Test 1: Normal healing")
health.heal(50)
print("Current health after healing by 50 from 90: " + str(health.current))
# Should be 100 (capped at max_health)

print("\nTest 2: Overhealing test")
health.current = 90
health.heal(20)
print("Current health after healing by 20 from 90: " + str(health.current))
# Should be 100 (capped at max_health)

print("\nTest 3: Dead entity healing")
health.current = 0
health.heal(20)
print("Current health after healing by 20 when dead: " + str(health.current))
# Should remain 0

print("\nTest 4: Different max_health")
var health2 = Health.new()
health2.max_health = 40
health2.current = 30
health2.heal(100)
print("Current health after healing by 100 with max 40: " + str(health2.current))
# Should be 40 (capped at max_health)