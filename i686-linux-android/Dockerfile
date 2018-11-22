FROM debian:stretch

RUN set -eux; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gcc \
    libc-dev \
    libstdc++6:i386 \
    python \
    unzip \
    ; \
    rm -rf /var/lib/apt/lists/*;

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    CC_i686_linux_android=i686-linux-android-gcc \
    CXX_i686_linux_android=i686-linux-android-g++ \
    CARGO_TARGET_i686_LINUX_ANDROID_LINKER=i686-linux-android-gcc \
    PATH=/usr/local/cargo/bin:/usr/local/android/ndk/bin:$PATH

# Install ndk
RUN set -eux; \
    curl -O https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip; \
    unzip -q android-ndk-r18b-linux-x86_64.zip; \
    android-ndk-r18b/build/tools/make_standalone_toolchain.py \
    --install-dir /usr/local/android/ndk \
    --arch x86 \
    --api 21; \
    rm -rf android-ndk-r18b-linux-x86_64.zip android-ndk-r18b;

ARG TOOLCHAIN

RUN set -eux; \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain $TOOLCHAIN --no-modify-path; \
    rustup target add i686-linux-android; \
    chmod -R +w $RUSTUP_HOME $CARGO_HOME;


# Install sysimage
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends e2tools; \
    curl -O https://dl.google.com/android/repository/sys-img/android/x86-18_r03.zip; \
    unzip -q x86-18_r03.zip; \
    mkdir -p /system/bin; \
    mkdir -p /system/lib; \
    e2cp -p x86/system.img:/bin/linker /system/bin/; \
    e2cp -p x86/system.img:/lib/libdl.so /system/lib/; \
    e2cp -p x86/system.img:/lib/libc.so /system/lib/; \
    e2cp -p x86/system.img:/lib/libm.so /system/lib/; \
    e2cp -p x86/system.img:/lib/liblog.so /system/lib/; \
    apt-get purge --auto-remove -y e2tools; \
    rm -rf x86 x86-18_r03.zip;

COPY i686-linux-android/config /.cargo/config

ENV CC_x86_linux_android=i686-linux-android-gcc \
    CXX_x86_linux_android=i686-linux-android-g++ \
    CARGO_TARGET_i686_LINUX_ANDROID_AR=i686-linux-android-ar \
    CARGO_TARGET_x86_LINUX_ANDROID_LINKER=i686-linux-android-gcc
