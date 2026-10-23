// Formata valores em reais para exibição no portal.
module.exports = (valor) => `R$ ${valor.toFixed(2).replace('.', ',')}`;
