#!/usr/bin/env bash
# Laboratório de Git (E5): conflito resolvido com rebase, git revert e git bisect run.
# Roda num repositório novo, só local, dentro de ./laboratorio-git (ignorado pelo .gitignore).
#
# Como usar (no Linux/WSL, Git Bash ou macOS):
#   bash laboratorio/executar.sh 2>&1 | tee laboratorio/log-bruto.txt
# Depois comente o log (E5 pede "log comentado"): explique com suas palavras o que
# cada bloco mostra.
set -euo pipefail

AQUI="$(cd "$(dirname "$0")" && pwd)"
LAB="$AQUI/../laboratorio-git"
[ -e "$LAB" ] && { echo "Já existe $LAB. Apague a pasta e rode de novo."; exit 1; }

passo() { printf '\n########## %s\n' "$1"; }
mostrar() { printf '$ %s\n' "$*"; "$@"; }

mkdir "$LAB" && cd "$LAB"
git init -q -b main
git config user.name  "Joao Pedro Fonseca"
git config user.email "laboratorio@exemplo.invalid"

mkdir -p apps/api
printf '{"timeout": 30, "retries": 1}\n' > apps/api/config.json
cat > apps/api/total.cjs <<'EOF'
module.exports = (preco, quantidade) => preco * quantidade;
EOF
cat > teste.cjs <<'EOF'
const assert = require('node:assert/strict');
const total = require('./apps/api/total.cjs');
assert.equal(total(10, 3), 30);
console.log('PASS: total correto');
EOF
git add . && git commit -q -m "chore: iniciar laboratorio"

passo "1) CONFLITO: duas branches privadas mudam a MESMA linha"
git switch -q -c feat/mais-tentativas
printf '{"timeout": 30, "retries": 5}\n' > apps/api/config.json
git commit -q -am "feat(api): aumentar tentativas"
git switch -q main
git switch -q -c fix/timeout
printf '{"timeout": 90, "retries": 1}\n' > apps/api/config.json
git commit -q -am "fix(api): ampliar timeout"
git switch -q main
mostrar git merge --ff-only fix/timeout

passo "1b) rebase da branch atrasada: o Git para no conflito"
git switch -q feat/mais-tentativas
mostrar git rebase main || true
mostrar git status --short
echo "--- arquivo em conflito:"; cat apps/api/config.json
echo "--- resolução: manter as duas intenções (timeout 90 e retries 5)"
printf '{"timeout": 90, "retries": 5}\n' > apps/api/config.json
mostrar git add apps/api/config.json
mostrar env GIT_EDITOR=true git rebase --continue
mostrar node teste.cjs
git switch -q main
mostrar git merge --ff-only feat/mais-tentativas

passo "2) REVERT: desfazer um commit que já está na main, sem reescrever histórico"
git switch -q -c feat/banner
echo "Campanha de fim de ano" > banner.txt
git add banner.txt && git commit -q -m "feat(portal): incluir banner"
git switch -q main && git merge -q --ff-only feat/banner
BANNER="$(git rev-parse HEAD)"
git switch -q -c fix/reverter-banner
mostrar git revert --no-edit "$BANNER"
git switch -q main && git merge -q --ff-only fix/reverter-banner
mostrar git log --oneline -4
test ! -e banner.txt && echo "banner.txt removido pelo revert; histórico preservado"

passo "3) BISECT: achar automaticamente o commit que quebrou o teste"
BOM="$(git rev-parse HEAD)"
git switch -q -c feat/varios-commits
echo "peças" > catalogo.txt && git add . && git commit -q -m "docs: descrever catalogo"
echo "azul"  > cor.txt      && git add . && git commit -q -m "style(ui): definir cor"
cat > apps/api/total.cjs <<'EOF'
module.exports = (preco, quantidade) => preco + quantidade;
EOF
git commit -q -am "refactor(api): simplificar total (introduz bug de propósito)"
BUG="$(git rev-parse HEAD)"
echo "regras" > regras.txt  && git add . && git commit -q -m "docs(prompts): registrar regras"
git switch -q main && git merge -q --ff-only feat/varios-commits
RUIM="$(git rev-parse HEAD)"
mostrar git bisect start "$RUIM" "$BOM"
mostrar git bisect run node teste.cjs || true
ACHADO="$(git rev-parse refs/bisect/bad)"
mostrar git bisect log
git bisect reset >/dev/null 2>&1
[ "$ACHADO" = "$BUG" ] && echo "OK: bisect encontrou exatamente o commit inserido ($BUG)" \
                       || { echo "ERRO: bisect apontou outro commit"; exit 1; }

passo "3b) recuperar: revert do commit com bug"
git switch -q -c fix/remover-bug
mostrar git revert --no-edit "$BUG"
git switch -q main && git merge -q --ff-only fix/remover-bug
mostrar node teste.cjs

passo "RESUMO"
mostrar git log --graph --oneline --all
mostrar git status --short
mostrar git fsck --full
