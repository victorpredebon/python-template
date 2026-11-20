# Modelo de ameaças — victorpredebon/python-template

> Modelo de ameaças usado pelos scans de segurança do Devin. Fatos marcados **[mantenedor]** foram confirmados pelo mantenedor; o resto descreve o código.

## Visão geral e fronteiras de confiança
- **python-template**: boilerplate Python público (template do GitHub). Não expõe serviço de rede; o único código de aplicação é o pacote `src/calculator/` (`sum_numbers` e o entry point `cli.main`). Quem usa o template herda CI, hooks e dependências.
- Fronteiras: (1) contribuidor externo → PR no GitHub → CI; (2) CI → registro PyPI / GitHub Actions de terceiros; (3) job de release no `main` → push de tag/versão com `GITHUB_TOKEN`; (4) desenvolvedor local → `make install` / pre-commit.

## Componentes
| Nome | Código |
|---|---|
| **App** | `src/calculator/` |
| **CI/CD** | `.github/workflows/ci.yml` (jobs `quality` e `release`), `.github/actions/setup-poetry` |
| **Dev tooling** | `Makefile`, `.pre-commit-config.yaml`, `pyproject.toml`, `poetry.lock`, `.vscode/` |

## Pontos de entrada
- PRs para `main`, push, agendamento semanal e `workflow_dispatch` disparam o job `quality` (`make install`, `pre-commit`, `pytest`, `pip-audit`, `deptry`).
- Push em `main` dispara `release` com `permissions: contents: write` e `semantic-release version`.
- PRs automáticos de bump de dependências (histórico mostra `chore(deps)`).
- Quem clona/usa o template executa `poetry install` e hooks locais.

## Ativos
- **[mantenedor]** Prioridade principal: cadeia de suprimentos e CI/CD (GitHub Actions, job de release, dependências e hooks).
- `GITHUB_TOKEN` com escrita no repositório durante o release; integridade das tags/versões e do `CHANGELOG.md`.
- Integridade do template que terceiros copiam (um hook ou dependência comprometida se propaga para projetos derivados).

## Perfis de atacante
- Contribuidor externo abrindo PR malicioso (código executado no CI de `quality`).
- Comprometimento de dependência PyPI ou de Action de terceiros (Actions fixadas por SHA de commit; hooks `pre-commit-hooks` ainda por tag).
- Usuário do template (vítima downstream) — não atacante.

## Controles existentes
- Dependabot (`.github/dependabot.yml`) abre PRs de bump; `poetry.lock` fixa versões; `pip-audit` no CI, bloqueante, também em execução semanal agendada; token do workflow com `contents: read` por padrão (escrita só no job `release`); `persist-credentials: false` no job `quality`; Poetry fixado no CI; hooks `detect-private-key`, `check-added-large-files` e `check-merge-conflict`; `SECURITY.md` com canal privado de reporte; `deptry`; Ruff com `select = ["ALL"]` (inclui regras `S`/bandit); mypy; Commitizen.
- Gatilho `pull_request` (não `pull_request_target`): PRs de forks não recebem segredos nem token com escrita.

## Fora de escopo / risco aceito
- O mantenedor não descartou nenhum atacante nem superfície explicitamente **[mantenedor]**.

## Observações
- Nenhum repositório de infraestrutura existe **[mantenedor]**; o modelo não cobre deploy.
