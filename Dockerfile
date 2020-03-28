# ffmpeg - http://ffmpeg.org/download.html
# From https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
# 
FROM buildpack-deps:18.04 as libs
WORKDIR /tmp/ffmpeg-static

LABEL maintainer="YuccaStream Developers <info@yuccastream.com> , <https://yuccastream.com>"
LABEL io.yucca.ffmpeg.libs=true

ARG CPROC=1
ENV DEBIAN_FRONTEND=noninteractive
ENV MAKEFLAGS=-j${CPROC}
ENV PREFIX=/tmp/ffmpeg-static

RUN set -xe && \
        apt-get -yqq update && \
        apt-get install -yq --no-install-recommends \
        autoconf \
        automake \
        build-essential \
        cmake \
        git \
        pkg-config \
        wget \
        yasm \
        libssl-dev

### nasm install
ARG NASM_VERSION=2.14.02
RUN set -xe && \
        DIR=/tmp/nasm && mkdir "${DIR}" && cd "${DIR}" && \
        curl -sL http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.xz | \
        tar -Jx --strip-components=1 && \
        ./configure && \
        make "${MAKEFLAGS}" && \
        make install

### x264 http://www.videolan.org/developers/x264.html
ARG X264_VERSION=x264-snapshot-20191009-2245-stable
RUN set -xe &&  \
        DIR=/tmp/x264 && mkdir "${DIR}" && cd "${DIR}" && \
        curl -sL https://download.videolan.org/pub/videolan/x264/snapshots/${X264_VERSION}.tar.bz2 | \
        tar -jx --strip-components=1 && \
        ./configure --prefix="${PREFIX}" --enable-static --enable-pic && \
        make "${MAKEFLAGS}" && \
        make install

# set pkg-config
ENV PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig
RUN set -xe \
        && pkg-config --list-all

### ffmpeg https://ffmpeg.org/releases
ARG FFMPEG_VERSION=snapshot
RUN set -xe &&  \
        DIR=/tmp/ffmpeg_build && mkdir -p "${DIR}" && cd "${DIR}" && \
        curl -sL https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | \
        tar -jx --strip-components=1  && \
        ./configure \
        --disable-debug \
        --disable-doc \
        --disable-shared \
        --enable-filters \
        --enable-gpl  \
        --enable-libx264 \
        --enable-nonfree \
        --enable-openssl \
        --enable-static \
        --enable-version3 \
        --extra-cflags="-I--prefix=${PREFIX}/include -static" \
        --extra-ldflags="-L--prefix=${PREFIX}/lib -static" \
        --extra-version=jidckii \
        --pkg-config-flags="--static" \
        --prefix="${PREFIX}" \
        && make "${MAKEFLAGS}"
RUN set -xe &&  \
        DIR=/tmp/ffmpeg && mkdir -p "${DIR}" && cd "${DIR}" && \
        make install
