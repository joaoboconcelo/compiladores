// Simula o pagamento de uma divida e mostra o custo total dos juros.
funcao real juros(real saldo, real taxa) {
  retorne saldo * taxa;
}

funcao vazio principal() {
  real saldo = 1000.0;
  real taxa = 0.02;
  real parcela = 200.0;
  real total = 0.0;
  inteiro mes = 0;
  escreva("Financiamento de 1000.00, juros de 2% ao mes");
  enquanto (saldo > 0.0) {
    mes = mes + 1;
    saldo = saldo + juros(saldo, taxa);
    real pagamento = parcela;
    se (saldo < parcela) {
      pagamento = saldo;
    }
    saldo = saldo - pagamento;
    total = total + pagamento;
    escreva("Mes");
    escreva(mes);
    escreva("Pagamento");
    escreva(pagamento);
    escreva("Saldo restante");
    escreva(saldo);
  }
  escreva("Total pago");
  escreva(total);
  escreva("Total de juros");
  escreva(total - 1000.0);
}
