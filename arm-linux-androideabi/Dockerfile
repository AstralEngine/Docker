FROM debian:stretch

RUN set -eux; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    default-jdk \
    gcc \
    libc-dev \
    libstdc++6:i386 \
    python \
    unzip \
    ; \
    rm -rf /var/lib/apt/lists/*;

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CARGO_TARGET_ARM_LINUX_ANDROIDEABI_LINKER=arm-linux-androideabi-gcc \
    CARGO_TARGET_ARM_LINUX_ANDROIDEABI_RUNNER=runtest \
    HOME=/home \
    PATH=/usr/local/cargo/bin:/usr/local/android/ndk/bin:/usr/local/android/sdk/tools:/usr/local/android/sdk/tools/bin:/usr/local/android/sdk/platform-tools:$PATH

# Install ndk
RUN set -eux; \
    curl -O https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip; \
    unzip -q android-ndk-r18b-linux-x86_64.zip; \
    android-ndk-r18b/build/tools/make_standalone_toolchain.py \
    --install-dir /usr/local/android/ndk \
    --arch arm \
    --api 18; \
    rm -rf android-ndk-r18b-linux-x86_64.zip android-ndk-r18b;

# Install sdk
RUN set -eux; \
    curl -O https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip; \
    unzip -q sdk-tools-linux-4333796.zip -d /usr/local/android/sdk; \
    echo "yes" | sdkmanager --no_https \
    "emulator" \
    "platform-tools" \
    "platforms;android-18" \
    "system-images;android-18;default;armeabi-v7a" \
    > /dev/null; \
    rm -rf sdk-tools-linux-433796.zip;

# Create emulator
RUN set -eux; \
    echo "no" | avdmanager create avd \
    --name arm \
    --package "system-images;android-18;default;armeabi-v7a";

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
    rustup target add arm-linux-androideabi; \
    chmod -R +w $RUSTUP_HOME $CARGO_HOME; \
    rustc /usr/src/runtest.rs -o /usr/bin/runtest

ENTRYPOINT [ \
    "bash", \
    "-c", \
    "/usr/local/android/sdk/emulator/emulator @arm -no-window & \
    exec \"$@\"", \
    "--" \
    ]
