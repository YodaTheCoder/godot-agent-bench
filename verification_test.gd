# Manually verifying our fix
print("==== VERIFICATION TEST ====")

# Test Case 1: fire_rate = 4.0, should allow shots every 0.25 seconds
print("\nTest 1: fire_rate = 4.0")
var last_shot_time = -INF
var fire_rate = 4.0
var required_interval = 1.0 / fire_rate
print("Required interval = %s seconds" % required_interval)

# First shot (any time)
var now = 0.0
var time_since_last = now - last_shot_time
print("First shot at t=%s, time since last = %s >= required %s ? %s" % [now, time_since_last, required_interval, time_since_last >= required_interval])

# Second shot attempt at t=0.2 (should fail)
now = 0.2
time_since_last = now - 0.0  # last_shot_time was 0.0 after first shot
print("Second shot at t=%s, time since last = %s >= required %s ? %s" % [now, time_since_last, required_interval, time_since_last >= required_interval])

# Third shot attempt at t=0.25 (should pass)
now = 0.25
time_since_last = now - 0.0
print("Third shot at t=%s, time since last = %s >= required %s ? %s" % [now, time_since_last, required_interval, time_since_last >= required_interval])

print("\nTest 2: fire_rate = 2.0")
last_shot_time = -INF
fire_rate = 2.0
required_interval = 1.0 / fire_rate
print("Required interval = %s seconds" % required_interval)

# First shot
now = 0.0
time_since_last = now - last_shot_time
print("First shot at t=%s, time since last = %s >= required %s ? %s" % [now, time_since_last, required_interval, time_since_last >= required_interval])

# Second shot attempt at t=0.4 (should fail)
now = 0.4
time_since_last = now - 0.0
print("Second shot at t=%s, time since last = %s >= required %s ? %s" % [now, time_since_last, required_interval, time_since_last >= required_interval])

# Third shot attempt at t=0.5 (should pass)
now = 0.5
time_since_last = now - 0.0
print("Third shot at t=%s, time since last = %s >= required %s ? %s" % [now, time_since_last, required_interval, time_since_last >= required_interval])
