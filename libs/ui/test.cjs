const assert = require('node:assert/strict');
const moeda = require('./moeda.cjs');

assert.equal(moeda(30), 'R$ 30,00');
assert.equal(moeda(2.5), 'R$ 2,50');
console.log('PASS ui: formato de moeda');
