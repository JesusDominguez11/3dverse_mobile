FROM ubuntu:22.04

# Configura variables de entorno críticas ANTES de las instalaciones
ENV FLUTTER_ROOT=/opt/flutter \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    PATH="/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:${PATH}" \
    FLUTTER_WINDOWS_PATH_COMPAT=0

# Instala dependencias con rutas limpias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl git unzip xz-utils libglu1-mesa-dev \
    ca-certificates openjdk-17-jdk wget \
    clang cmake ninja-build pkg-config libgtk-3-dev && \
    rm -rf /var/lib/apt/lists/*

# Instala Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_ROOT} && \
    flutter precache && \
    flutter config --android-sdk ${ANDROID_SDK_ROOT} && \
    flutter config --enable-web && \
    flutter doctor

# Instala Android SDK con rutas limpias
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# Acepta licencias e instala componentes
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-35" "build-tools;34.0.0" "ndk;26.3.11579264"

# Parche crítico: Corrige rutas en flutter.gradle
RUN sed -i 's@File(path)@File(path.replace("\\\\", "/"))@g' ${FLUTTER_ROOT}/packages/flutter_tools/gradle/flutter.gradle

WORKDIR /app