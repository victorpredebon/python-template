# Modelo de ameaças — victorpredebon/python-template

> Modelo de ameaças usado pelos scans de segurança do Devin. Fatos marcados **[mantenedor]** foram confirmados pelo mantenedor; o resto descreve o código.

## Visão geral e fronteiras de confiança
- **python-template**: boilerplate Python público (template do GitHub). Não expõe serviço de rede; o único código de aplicação é `calculator/calc.py` (`sum_numbers`) e `main.py`. Quem usa o template herda CI, hooks e dependências.
- Fronteiras: (1) contribuidor externo → PR no GitHub → CI; (2) CI → registro PyPI / GitHub Actions de terceiros; (3) job de release no `main` → push de tag/versão com `GITHUB_TOKEN`; (4) desenvolvedor local → `make install` / pre-commit.

## Componentes
| Nome | Código |
|---|---|
| **App** | `main.py`, `calculator/` |
| **CI/CD** | `.github/workflows/ci.yml` (jobs `quality` e `release`) |
| **Dev tooling** | `Makefile`, `.pre-commit-config.yaml`, `pyproject.toml`, `poetry.lock`, `.vscode/` |

## Pontos de entrada
- PRs para `main` disparam o job `quality` (`make install`, `pre-commit`, `pytest`, `pip-audit`, `deptry`).
- Push em `main` dispara `release` com `permissions: contents: write` e `semantic-release version`.
- PRs automáticos de bump de dependências (histórico mostra `chore(deps)`).
- Quem clona/usa o template executa `poetry install` e hooks locais.

## Ativos
- **[mantenedor]** Prioridade principal: cadeia de suprimentos e CI/CD (GitHub Actions, job de release, dependências e hooks).
- `GITHUB_TOKEN` com escrita no repositório durante o release; integridade das tags/versões e do `CHANGELOG.md`.
- Integridade do template que terceiros copiam (um hook ou dependência comprometida se propaga para projetos derivados).

## Perfis de atacante
- Contribuidor externo abrindo PR malicioso (código executado no CI de `quality`).
- Comprometimento de dependência PyPI ou de Action de terceiros (Actions fixadas por tag `@v6`/`@v5`, não por SHA; hooks `pre-commit-hooks` por tag).
- Usuário do template (vítima downstream) — não atacante.

## Controles existentes
- Dependabot (`.github/dependabot.yml`) abre PRs de bump; `poetry.lock` fixa versões; `pip-audit` no CI (com `continue-on-error: true`, não bloqueia); `deptry`; Ruff com `select = ["ALL"]` (inclui regras `S`/bandit); mypy; Commitizen.
- Gatilho `pull_request` (não `pull_request_target`): PRs de forks não recebem segredos nem token com escrita.

## Fora de escopo / risco aceito
- O mantenedor não descartou nenhum atacante nem superfície explicitamente **[mantenedor]**.

## Observações
- Nenhum repositório de infraestrutura existe **[mantenedor]**; o modelo não cobre deploy.
