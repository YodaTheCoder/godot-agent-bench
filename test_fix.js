// Test script to verify the fix for Health.heal() function

// Simulate the fixed heal function
function testHeal(maxHealth, currentHealth, amount) {
    if (currentHealth === 0) {
        return currentHealth; // Can't heal dead entity
    }
    return Math.min(currentHealth + amount, maxHealth);
}

// Test cases from requirements:
console.log("Test 1: max_health = 100, damage(10), then heal(50)");
let result1 = testHeal(100, 90, 50);
console.log("Result:", result1, "Expected: 100", result1 === 100 ? "✓" : "✗");

console.log("\nTest 2: At full health, heal(25)");
let result2 = testHeal(100, 100, 25);
console.log("Result:", result2, "Expected: 100", result2 === 100 ? "✓" : "✗");

console.log("\nTest 3: max_health = 40, damage(10), then heal(100)");
let result3 = testHeal(40, 30, 100);
console.log("Result:", result3, "Expected: 40", result3 === 40 ? "✓" : "✗");

console.log("\nTest 4: damage(100) (dead), then heal(20)");
let result4 = testHeal(100, 0, 20);
console.log("Result:", result4, "Expected: 0", result4 === 0 ? "✓" : "✗");

console.log("\nTest 5: Healing below max still works");
let result5 = testHeal(100, 50, 20);
console.log("Result:", result5, "Expected: 70", result5 === 70 ? "✓" : "✗");