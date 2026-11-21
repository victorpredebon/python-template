# syntax=docker/dockerfile:1
# Production image: `docker build -t calculator .` then `docker run --rm calculator`.
# Two stages: uv builds a virtualenv with the package and its runtime dependencies
# (no dev tools, no source tree), and the final image only copies that virtualenv
# onto a slim Python, running as an unprivileged user.

ARG PYTHON_VERSION=3.14

FROM ghcr.io/astral-sh/uv:0.11.32 AS uv

FROM python:${PYTHON_VERSION}-slim AS builder
COPY --from=uv /uv /usr/local/bin/uv
# Use the image's Python (not a download), compile bytecode for faster startup, and
# copy files out of the cache mount so the virtualenv is self-contained.
ENV UV_PYTHON=/usr/local/bin/python3 \
    UV_PYTHON_DOWNLOADS=never \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy
WORKDIR /app

# Dependencies first, in their own layer: rebuilt only when uv.lock changes.
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-dev --no-install-project

# Then the project itself, installed as a regular (non-editable) package.
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev --no-editable

FROM python:${PYTHON_VERSION}-slim
RUN groupadd --system app && useradd --system --gid app --no-create-home app
COPY --from=builder --chown=app:app /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:${PATH}" \
    PYTHONUNBUFFERED=1
USER app
ENTRYPOINT ["calculator"]
