# Contribuição — Carparts

Responsável: Joao Pedro Fonseca — RA 26179863

## 1. Estratégia de branches

Adotamos um desenvolvimento próximo de trunk-based: branches curtas, que saem da `main` e voltam a ela em até 2 dias úteis, porque com 4 devs, 1 designer e ~40 PRs por semana integrar em pedaços pequenos evita conflitos como o do laboratório e mantém cada PR fácil de revisar e reverter.

- **Vida máxima da branch:** 2 dias úteis, da criação ao merge na `main`. Se passar disso, divida o trabalho em PRs menores ou faça rebase na `main` e peça nova revisão antes de continuar.
- **Funcionalidade incompleta:** entra na `main` com feature flag desligada.
- **Nomes de branch:** `feat/`, `fix/`, `docs/`, `refactor/`, `chore/` (mesmos tipos dos commits). Exemplo: `feat/politica-carparts`.
- **Tamanho do PR:** até ~200 linhas.
- Por quê: branches longas ficam para trás da `main` e geram conflitos (foi o que aconteceu no laboratório, em `apps/api/config.json`). O lead time de 11 → 2 dias é uma **meta**, não um resultado já medido.

## 2. Commits (Conventional Commits)

Formato: `tipo(escopo): descrição curta`. Tipos usados: `feat`, `fix`, `docs`, `refactor`, `chore`. Mudança que quebra compatibilidade leva `!` após o tipo ou o rodapé `BREAKING CHANGE:`.

Exemplos reais do repositório e do laboratório de Git:

- `feat(devops): estrutura inicial do monorepo, CI e laboratório Git` (PR #1)
- `docs(lab): log bruto do laboratorio Git e diagnostico do repositorio` (PR #1)
- `fix(api): ampliar timeout` (laboratório)

### Changelog

Hoje o repositório **não tem** `CHANGELOG.md` nem ferramenta de release configurada. A regra, a partir da primeira release, é montar o changelog à mão a partir dos Conventional Commits, com `git log` filtrado por tipo (por exemplo, `git log --oneline --grep="^feat"`), agrupando em `feat`, `fix`, `docs` etc. e destacando qualquer `BREAKING CHANGE`. Ferramentas como `git-cliff` ou `release-please` podem automatizar isso no futuro, mas não estão em uso.

## 3. Atualizar a branch com a `main`

- **Rebase** só em branch ainda privada (só minha), para manter o histórico linear, como exige a política da `main`.
- **Histórico compartilhado nunca é reescrito.** Para desfazer algo que já está na `main`, usa-se `git revert`, que acrescenta um commit novo e não exige force push (que a `main` proíbe).
- Nunca usar `git push --force` nem `git reset --hard` em branch compartilhada.

## 4. PRs de agentes de IA

- O PR deve informar: ferramenta usada, objetivo, pastas afetadas, riscos, testes executados e resultados reais (não descrever teste que não foi rodado).
- Quem abre o PR assume a responsabilidade pelo conteúdo.
- A aprovação é de um code owner humano, diferente do autor, registrada no GitHub.
- Mudanças em `prompts/` sempre têm revisão do responsável (code owner).

## 5. Proteção, revisão e integração

Regra ativa na `main`: PR obrigatório com 1 aprovação, revisão de code owners, descarte de aprovações antigas a cada novo push, aprovação do último push por outra pessoa, conversas resolvidas, histórico linear, check obrigatório `ci-obrigatorio` (origem GitHub Actions) com branch atualizada, valendo também para administradores, sem force push e sem exclusão.

**Merge queue: indisponível.** Em repositório pessoal o GitHub não oferece merge queue (a API responde HTTP 422); ela só existe em repositório público de uma organização (ou privado em organização com Enterprise Cloud). Por isso a integração é feita por PR aprovado, com o check `ci-obrigatorio` verde. O workflow de CI já tem o gatilho `merge_group`, para funcionar caso o repositório migre para uma organização.

## 6. Medição em duas semanas

- **O que medir:** lead time (da abertura do PR ao merge), tamanho dos PRs e tempo de checkout do CI.
- **Quando:** antes e depois da adoção das regras deste documento, ao longo de duas semanas.
- **Meta de lead time:** de 11 para 2 dias. É uma meta do enunciado, ainda não medida.
- **Já medido (benchmark, 3 execuções por configuração no mesmo commit):** checkout médio de 762 ms (completo) contra 952 ms (enxuto). Em repositório pequeno o checkout enxuto não ganhou.
