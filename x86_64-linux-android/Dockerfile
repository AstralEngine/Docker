FROM debian:stretch

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gcc \
    libc-dev \
    python \
    unzip \
    ; \
    rm -rf /var/lib/apt/lists/*;

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CC_x86_64_linux_android=x86_64-linux-android-gcc \
    CXX_x86_64_linux_android=x86_64-linux-android-g++ \
    CARGO_TARGET_X86_64_LINUX_ANDROID_LINKER=x86_64-linux-android-gcc \
    PATH=/usr/local/cargo/bin:/usr/local/android/ndk/bin:$PATH

# Install ndk
RUN set -eux; \
    curl -O https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip; \
    unzip -q android-ndk-r18b-linux-x86_64.zip; \
    android-ndk-r18b/build/tools/make_standalone_toolchain.py \
    --install-dir /usr/local/android/ndk \
    --arch x86_64 \
    --api 21; \
    rm -rf android-ndk-r18b-linux-x86_64.zip android-ndk-r18b;

# Install sysimage
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends e2tools; \
    curl -O https://dl.google.com/android/repository/sys-img/android/x86_64-21_r05.zip; \
    unzip -q x86_64-21_r05.zip; \
    mkdir -p /system/bin; \
    mkdir -p /system/lib64; \
    e2cp -p x86_64/system.img:/bin/linker64 /system/bin/; \
    e2cp -p x86_64/system.img:/lib64/libdl.so /system/lib64/; \
    e2cp -p x86_64/system.img:/lib64/libc.so /system/lib64/; \
    e2cp -p x86_64/system.img:/lib64/libm.so /system/lib64/; \
    apt-get purge --auto-remove -y e2tools; \
    rm -rf x86_64 x86_64-21_r05.zip;

ARG TOOLCHAIN

RUN set -eux; \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $TOOLCHAIN --no-modify-path; \
    rustup target add x86_64-linux-android; \
    chmod -R +w $RUSTUP_HOME $CARGO_HOME;
