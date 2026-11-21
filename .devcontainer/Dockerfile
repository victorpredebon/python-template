# Development container: Ubuntu with git and make, plus a pinned uv. uv installs the
# Python version in .python-version and the locked dependencies (postCreateCommand).
FROM ghcr.io/astral-sh/uv:0.13.9 AS uv

FROM mcr.microsoft.com/devcontainers/base:noble
COPY --from=uv /uv /uvx /usr/local/bin/
