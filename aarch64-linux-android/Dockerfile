FROM debian:stretch

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    default-jdk \
    gcc \
    libc-dev \
    python \
    unzip \
    ; \
    rm -rf /var/lib/apt/lists/*;

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=aarch64-linux-android-gcc \
    CARGO_TARGET_AARCH64_LINUX_ANDROID_RUNNER=runtest \
    HOME=/home \
    PATH=/usr/local/cargo/bin:/usr/local/android/ndk/bin:/usr/local/android/sdk/tools:/usr/local/android/sdk/tools/bin:/usr/local/android/sdk/platform-tools:$PATH

# Install ndk
RUN set -eux; \
    curl -O https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip; \
    unzip -q android-ndk-r18b-linux-x86_64.zip; \
    android-ndk-r18b/build/tools/make_standalone_toolchain.py \
    --install-dir /usr/local/android/ndk \
    --arch arm64 \
    --api 24; \
    rm -rf android-ndk-r18b-linux-x86_64.zip android-ndk-r18b;

# Install sdk
RUN set -eux; \
    curl -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip; \
    unzip -q sdk-tools-linux-4333796.zip -d /usr/local/android/sdk; \
    echo "yes" | sdkmanager --no_https \
    "emulator" \
    "platform-tools" \
    "platforms;android-24" \
    "system-images;android-24;google_apis;arm64-v8a"; \
    rm -rf sdk-tools-linux-433796.zip;

# Create emulator
RUN set -eux; \
    echo "no" | avdmanager create avd \
    --name aarch64 \
    --package "system-images;android-24;google_apis;arm64-v8a";

ADD runtest-android.rs /usr/src/runtest.rs

RUN set -eux; \
    mkdir -p /home; \
    mv /root/.android /home/; \
    chmod -R 777 /home;

# Invalidate cache after this line
ARG DATE=

ARG TOOLCHAIN

RUN set -eux; \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $TOOLCHAIN --no-modify-path; \
    rustup target add aarch64-linux-android; \
    chmod -R +w $RUSTUP_HOME $CARGO_HOME; \
    rustc /usr/src/runtest.rs -o /usr/bin/runtest

ENTRYPOINT [ \
    "bash", \
    "-c", \
    "/usr/local/android/sdk/emulator/emulator @aarch64 -no-window & \
    exec \"$@\"", \
    "--" \
    ]
