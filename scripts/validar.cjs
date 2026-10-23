// Uso: node scripts/validar.cjs <apps/api|apps/portal|libs/ui|prompts|all>
const fs = require('node:fs');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

const raiz = path.resolve(__dirname, '..');
const componentes = ['apps/api', 'apps/portal', 'libs/ui', 'prompts'];
const alvo = process.argv[2];

if (alvo !== 'all' && !componentes.includes(alvo)) {
  console.error(`Componente inválido: ${alvo}`);
  process.exit(2);
}

function validarPrompts() {
  const texto = fs.readFileSync(path.join(raiz, 'prompts', 'revisao.md'), 'utf8');
  if (!texto.includes('REVISAO_HUMANA_OBRIGATORIA')) {
    console.error('FAIL prompts: falta o requisito de revisão humana');
    process.exit(1);
  }
  console.log('PASS prompts: requisito de revisão humana presente');
}

function validarCodigo(componente) {
  const pasta = path.join(raiz, componente);
  for (const arquivo of fs.readdirSync(pasta).filter((f) => f.endsWith('.cjs'))) {
    const sintaxe = spawnSync(process.execPath, ['--check', path.join(pasta, arquivo)], { stdio: 'inherit' });
    if (sintaxe.status !== 0) process.exit(1);
  }
  const teste = spawnSync(process.execPath, [path.join(pasta, 'test.cjs')], { stdio: 'inherit' });
  if (teste.status !== 0) process.exit(1);
}

for (const componente of alvo === 'all' ? componentes : [alvo]) {
  if (componente === 'prompts') validarPrompts();
  else validarCodigo(componente);
}
