// Cálculo simples de total de um pedido de peças.
function totalPedido(itens) {
  return itens.reduce((soma, { preco, quantidade }) => soma + preco * quantidade, 0);
}

module.exports = { totalPedido };
