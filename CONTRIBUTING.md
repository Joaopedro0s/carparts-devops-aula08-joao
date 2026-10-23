# Contribuição — Carparts

Responsável: Joao Pedro Fonseca — RA 26179863

> ESQUELETO PARA VOCÊ PREENCHER (entregável E2). Cada seção lista o que a atividade
> exige; as decisões e o texto final são seus. Apague estas instruções ao terminar.

## Estratégia de branches
- Modelo escolhido e por quê (a atividade pede trunk-based).
- Vida máxima de uma branch (um número, em dias úteis) e o que fazer se estourar.
- Como funcionalidades incompletas entram na main (feature flags).
- Padrão de nomes: `feat/…`, `fix/…`, e os demais prefixos que você quiser aceitar.
- Tamanho esperado de um PR.

## Commits
- Conventional Commits: formato, tipos aceitos, pelo menos 3 exemplos reais do repositório.
- Como indicar mudança incompatível (`!` e `BREAKING CHANGE`).
- Como o changelog da release é montado a partir dos commits.

## Atualizar a branch com a main
- Quando usar `rebase` (só commits ainda privados) e quando usar `merge`.
- Regra para histórico compartilhado: nunca reescrever; desfazer na main só com `git revert`.

## PRs de agentes de IA
- O que o PR precisa informar: ferramenta, objetivo, pastas afetadas, riscos, testes e resultados.
- Quem assume a responsabilidade e quem aprova (pessoa diferente do autor, registrada no GitHub).
- Regra especial para `prompts/`.

## Proteção, revisão e integração
- Checks obrigatórios (`ci-obrigatorio`), CODEOWNERS e conversas resolvidas.
- Merge queue: ativa ou indisponível? Se indisponível, escreva isso aqui com a evidência.

## Medição em duas semanas
- O que medir, quando (antes/depois) e qual é a meta de lead time.
