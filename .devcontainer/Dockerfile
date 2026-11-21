# Development container: Ubuntu with git and make, plus a pinned uv. uv installs the
# Python version in .python-version and the locked dependencies (postCreateCommand).
FROM ghcr.io/astral-sh/uv:0.13.9@sha256:d3b601f0c7b118bc1753febf7c41cc80981df678445e0254284eecf84db79a7d AS uv

FROM mcr.microsoft.com/devcontainers/base:noble@sha256:88171bb581e19bbb45db77a16a3a5475e2f9ddce025b044c2e5a69a6a1e24fa1
COPY --from=uv /uv /uvx /usr/local/bin/
