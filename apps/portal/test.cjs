// O portal depende de libs/ui: mudanças na biblioteca devem rodar este teste também.
const assert = require('node:assert/strict');
const moeda = require('../../libs/ui/moeda.cjs');
const { totalPedido } = require('../api/estoque.cjs');

const total = totalPedido([{ preco: 12.5, quantidade: 2 }]);
assert.equal(moeda(total), 'R$ 25,00');
console.log('PASS portal: total exibido com a biblioteca de UI');
