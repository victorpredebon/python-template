# Modelo de ameaças — victorpredebon/python-template

> Modelo de ameaças usado pelos scans de segurança do Devin. Fatos marcados **[mantenedor]** foram confirmados pelo mantenedor; o resto descreve o código.

## Visão geral e fronteiras de confiança
- **python-template**: boilerplate Python público (template do GitHub). Não expõe serviço de rede; o único código de aplicação é o pacote `src/calculator/` (`sum_numbers` e o entry point `cli.main`). Quem usa o template herda CI, hooks e dependências.
- Fronteiras: (1) contribuidor externo → PR no GitHub → CI; (2) CI → registro PyPI / GitHub Actions de terceiros; (3) job de release no `main` → push de tag/versão com `GITHUB_TOKEN`; (4) desenvolvedor local → `make install` / pre-commit.

## Componentes
| Nome | Código |
|---|---|
| **App** | `src/calculator/` |
| **CI/CD** | `.github/workflows/ci.yml` (jobs `lint`, `test`, `security`, `commits`, `dependency-review`, `build`, `ci-ok`, `release`), `codeql.yml`, `scorecard.yml`, `.github/actions/setup-uv` |
| **Dev tooling** | `Makefile`, `.pre-commit-config.yaml`, `pyproject.toml`, `uv.lock`, `.vscode/` |

## Pontos de entrada
- PRs para `main`, push, merge queue, agendamento semanal e `workflow_dispatch` disparam os jobs de qualidade (`make install`, `pre-commit`, `pytest`, `pip-audit`, `deptry`).
- Push em `main` dispara `build` (sem permissão de escrita e sem cache, gera wheel/sdist/SBOM) e `release` (environment `release`, `contents: write`, `id-token: write`, `attestations: write`), que atesta a proveniência, cria tag/release e anexa os artefatos.
- PRs automáticos de bump de dependências (histórico mostra `chore(deps)`).
- Quem clona/usa o template executa `make install` (`uv sync`) e hooks locais.

## Ativos
- **[mantenedor]** Prioridade principal: cadeia de suprimentos e CI/CD (GitHub Actions, job de release, dependências e hooks).
- `GITHUB_TOKEN` com escrita no repositório durante o release; integridade das tags/versões e do `CHANGELOG.md`.
- Integridade do template que terceiros copiam (um hook ou dependência comprometida se propaga para projetos derivados).

## Perfis de atacante
- Contribuidor externo abrindo PR malicioso (código executado no CI de `quality`).
- Comprometimento de dependência PyPI ou de Action de terceiros (Actions fixadas por SHA de commit; hooks `pre-commit-hooks` ainda por tag).
- Usuário do template (vítima downstream) — não atacante.
- Agente de IA (local ou em CI) induzido por prompt injection vinda de issues, PRs, dependências ou páginas web a alterar workflows, enfraquecer gates ou vazar segredos.

## Controles existentes
- Dependabot (`.github/dependabot.yml`) abre PRs de bump; `uv.lock` fixa versões (CI falha se estiver desatualizado) e ignora releases com menos de 7 dias (`exclude-newer`); `pip-audit` no CI, bloqueante, também em execução semanal agendada; token do workflow com `contents: read` por padrão (escrita só no job `release`); `persist-credentials: false` no job `quality`; uv fixado no CI (`required-version` no `pyproject.toml`); hooks `detect-private-key`, `check-added-large-files` e `check-merge-conflict`; `SECURITY.md` com canal privado de reporte; `permissions: {}` no topo dos workflows; zizmor e actionlint nos workflows (pre-commit/CI) e CodeQL para `actions`; dependency review em PRs; cooldown de 7 dias no Dependabot; build isolado do release (sem cache nem escrita); SBOM CycloneDX, SHA256SUMS e atestação SLSA de proveniência nos releases; job `ci-ok` agregado; validação de PR title/commits no CI; CODEOWNERS explícito para `.github/`, `pyproject.toml`, `uv.lock`, `AGENTS.md`; `AGENTS.md` com regras para agentes de IA; comentários de supressão (`noqa`, `type: ignore`, `ast-grep-ignore`, `pragma: no cover`, ...) proibidos sem exceção (hook do pre-commit e workflow `PR policy`); workflow `PR policy` que detecta testes pulados e mudanças de configuração de gates e exige o label `allow-gate-change` adicionado por um code owner humano (lido do branch base); um push posterior que mude gates de novo, ou reescreva o histórico, remove o label (o job tem `pull-requests: write` só para isso; sem permissão, falha fechado); mutation testing (mutmut); revisão independente opcional por Claude com ferramentas somente leitura e sem PRs de fork; hooks compartilhados em `.agents/hooks/` (ligados ao Claude Code, Codex, Gemini CLI e Copilot pelos configs em `.claude/`, `.codex/`, `.gemini/` e `.github/hooks/`) que bloqueiam pular hooks do git, force push e push no `main`, rodam os gates antes de o agente terminar (desativado em CI para não executar código do PR) e negam leitura de `.env`/chaves; `deptry`; Ruff com `select = ["ALL"]` (inclui regras `S`/bandit); mypy; Commitizen.
- Gatilho `pull_request` (não `pull_request_target`): PRs de forks não recebem segredos nem token com escrita.

## Fora de escopo / risco aceito
- O mantenedor não descartou nenhum atacante nem superfície explicitamente **[mantenedor]**.

## Observações
- Nenhum repositório de infraestrutura existe **[mantenedor]**; o modelo não cobre deploy.
