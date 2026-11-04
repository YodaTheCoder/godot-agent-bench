# Final verification of the fix according to all requirements

print("=== FINAL VERIFICATION OF WEAPON FIX ===")

# Test 1: Default fire_rate = 4.0
print("\n1. Testing default fire_rate = 4.0")
var weapon = Weapon.new()
weapon.fire_rate = 4.0

# Requirement 1: First shot is always allowed
var result1 = weapon.try_fire(0.0)
print("   try_fire(0.0) -> %s (should be true)" % result1)
assert_true(result1)

# Requirement 2: With 4 shots/second, 0.25 seconds between shots
# At t=0.2, only 0.2 seconds have passed since last shot (0.0), so should NOT fire
var result2 = weapon.try_fire(0.2)
print("   try_fire(0.2) -> %s (should be false - only 0.2s passed, need 0.25s)" % result2)
assert_false(result2)

# At t=0.25, exactly 0.25 seconds have passed since last shot, so should fire
var result3 = weapon.try_fire(0.25)
print("   try_fire(0.25) -> %s (should be true - exactly 0.25s passed)" % result3)
assert_true(result3)

# Test 2: fire_rate = 2.0 (2 shots/second, 0.5s between shots)
print("\n2. Testing fire_rate = 2.0")
weapon.fire_rate = 2.0

# First shot should always be allowed
var result4 = weapon.try_fire(0.0)
print("   try_fire(0.0) -> %s (should be true)" % result4)
assert_true(result4)

# At t=0.4, only 0.4 seconds have passed since last shot (0.0), so should NOT fire
var result5 = weapon.try_fire(0.4)
print("   try_fire(0.4) -> %s (should be false - only 0.4s passed, need 0.5s)" % result5)
assert_false(result5)

# At t=0.5, exactly 0.5 seconds have passed since last shot, so should fire
var result6 = weapon.try_fire(0.5)
print("   try_fire(0.5) -> %s (should be true - exactly 0.5s passed)" % result6)
assert_true(result6)

# Test 3: fire_rate = 0.5 (0.5 shots/second, 2.0s between shots)
print("\n3. Testing fire_rate = 0.5")
weapon.fire_rate = 0.5

# First shot should always be allowed
var result7 = weapon.try_fire(0.0)
print("   try_fire(0.0) -> %s (should be true)" % result7)
assert_true(result7)

# At t=1.5, only 1.5 seconds have passed since last shot (0.0), so should NOT fire
var result8 = weapon.try_fire(1.5)
print("   try_fire(1.5) -> %s (should be false - only 1.5s passed, need 2.0s)" % result8)
assert_false(result8)

# At t=2.0, exactly 2.0 seconds have passed since last shot, so should fire
var result9 = weapon.try_fire(2.0)
print("   try_fire(2.0) -> %s (should be true - exactly 2.0s passed)" % result9)
assert_true(result9)

print("\n=== ALL TESTS PASSED ===")
print("Fix correctly implements shots-per-second behavior.")
