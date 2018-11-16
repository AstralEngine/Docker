ARG TARGET=

FROM $TARGET

ARG TOOLCHAIN=

RUN set -eux; \
    curl https://sh.rustup.rs -sSf | \
    sh -s -- -y --default-toolchain $TOOLCHAIN-x86_64-unknown-linux-gnu --no-modify-path; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME;
