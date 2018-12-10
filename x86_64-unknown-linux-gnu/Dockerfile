FROM debian:stable-slim

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gcc \
    libc6-dev \
    ; \
    rm -rf /var/lib/apt/lists/*;

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

# Invalidate cache after this line
ARG DATE=

ARG TOOLCHAIN

RUN set -eux; \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $TOOLCHAIN --default-host x86_64-unknown-linux-gnu --no-modify-path; \
    chmod -R +w $RUSTUP_HOME $CARGO_HOME; \
    rustup component add rustfmt; \
    rustup component add clippy;
