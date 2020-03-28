# Minimal static build ffmpeg

## build
Build snapshot version:  
```
make
```
Build a specific version:  
```
FFVERSION=4.2.2 make
```
After assembly, there will be 2 binary files in the current directory `ffmpeg`, `ffprobe`.


```
$ ./ffmpeg -version

ffmpeg version N-97089-gca7a192-jidckii Copyright (c) 2000-2020 the FFmpeg developers
built with gcc 7 (Ubuntu 7.5.0-3ubuntu1~18.04)
configuration: --disable-debug --disable-doc --disable-shared --enable-filters --enable-gpl --enable-libx264 --enable-nonfree --enable-openssl --enable-static --enable-version3 --extra-cflags='-I--prefix=/tmp/ffmpeg-static/include -static' --extra-ldflags='-L--prefix=/tmp/ffmpeg-static/lib -static' --extra-version=jidckii --pkg-config-flags=--static --prefix=/tmp/ffmpeg-static
libavutil      56. 42.101 / 56. 42.101
libavcodec     58. 76.100 / 58. 76.100
libavformat    58. 42.100 / 58. 42.100
libavdevice    58.  9.103 / 58.  9.103
libavfilter     7. 77.100 /  7. 77.100
libswscale      5.  6.101 /  5.  6.101
libswresample   3.  6.100 /  3.  6.100
libpostproc    55.  6.100 / 55.  6.100
```