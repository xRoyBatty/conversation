// Simple test file
function add(a, b) {
  return a + b;
}

function multiply(a, b) {
  return a * b;
}

// Basic tests
console.log('Testing add function...');
console.assert(add(2, 3) === 5, 'add(2, 3) should equal 5');
console.assert(add(-1, 1) === 0, 'add(-1, 1) should equal 0');
console.log('add() tests passed!');

console.log('Testing multiply function...');
console.assert(multiply(2, 3) === 6, 'multiply(2, 3) should equal 6');
console.assert(multiply(5, 0) === 0, 'multiply(5, 0) should equal 0');
console.log('multiply() tests passed!');

console.log('All tests passed!');
