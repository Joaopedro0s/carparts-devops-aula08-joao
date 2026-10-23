const assert = require('node:assert/strict');
const { totalPedido } = require('./estoque.cjs');

assert.equal(totalPedido([{ preco: 10, quantidade: 3 }]), 30);
assert.equal(totalPedido([{ preco: 5, quantidade: 0 }]), 0);
assert.equal(totalPedido([{ preco: 2.5, quantidade: 2 }, { preco: 1, quantidade: 4 }]), 9);
console.log('PASS api: total do pedido');
