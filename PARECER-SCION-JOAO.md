# Parecer: Scion x Carparts

Joao Pedro Fonseca — RA 26179863 — Aula 08 (Git e Scion)
Fonte primária: Anthropic, "Redesigning source control" — https://www.anthropic.com/research/redesigning-source-control (publicado em 13/10/2026, atualizado em 15/10/2026; consultado em 23/10/2026). Os números do Scion são relatados pela própria Anthropic, sem verificação independente.

## 1. O que o Scion resolve

Segundo a Anthropic, o volume de merges e de CI no monorepo deles passou do que o Git suportava: de cerca de 2.500 merges por dia (maio de 2026) para mais de 30.000 (setembro de 2026), com cerca de 25 milhões de checkouts de CI por dia e um histórico da `main` de aproximadamente 100 GB. O Scion foi desenhado para esse cenário. O valor de 600+ PB por dia citado no post é uma **estimativa** sem otimizações, não uma medição.

## 2. Por que não se aplica à Carparts

- **Escala.** No cenário do enunciado (4 devs, 1 designer, cerca de 40 PRs por semana) o Git não é o gargalo. A diferença para a Anthropic é de várias ordens de grandeza.
- **Restrição e disponibilidade.** A equipe precisa continuar em Git e GitHub, e o Scion é interno, não foi lançado e, segundo o próprio post, não é um substituto do Git para uso geral.

## 3. Três ideias adotadas, cada uma ligada a uma métrica

1. **Checkout enxuto (sparse-checkout e fetch-depth).** Medi 3 execuções por configuração no mesmo commit (`58a0e8c`): checkout médio de 762 ms (completo) contra 952 ms (enxuto), e tempo total médio de 1.053 ms contra 1.778 ms. **Resultado negativo:** no repositório pequeno o checkout enxuto não compensa. O benefício esperado só apareceria em repositórios grandes, e isso não foi medido por mim.
2. **Gate automático antes do merge.** O check obrigatório `ci-obrigatorio` (origem GitHub Actions) passou nos 14 checks do PR #1, e a proteção da `main` está ativa. A merge queue **não está disponível**: segundo a documentação do GitHub ela só existe em repositório público de uma organização (ou privado em organização com Enterprise Cloud), e em repositório pessoal a API rejeita com HTTP 422. Esse erro eu vi na evidência do PR do colega Davi, não testei no meu repositório. O workflow já tem o gatilho `merge_group` para quando houver fila.
3. **PRs pequenos e de vida curta.** O conflito do laboratório em `apps/api/config.json` (duas branches mudando a mesma linha) mostra o custo de uma branch ficar para trás. Por isso a regra de 2 dias úteis de vida máxima e PRs de até ~200 linhas, no `CONTRIBUTING.md`.

## 4. O que é medido e o que é só meta

- **Medido:** o benchmark acima, o diagnóstico do repositório (30 objetos em 1 pack de 11,83 KiB), os 14 checks verdes e a proteção da `main` ativa.
- **Só meta ou dado do enunciado:** a redução do lead time de 11 para 2 dias é uma meta, ainda não medida. O tamanho do time (4 devs e 1 designer) e o ritmo de ~40 PRs por semana vêm do cenário do enunciado, não de uma medição minha.
