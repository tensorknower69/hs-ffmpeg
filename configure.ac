AC_INIT([Haskell FFMpeg bindings], [0.3.2])

AC_CONFIG_SRCDIR([hs-ffmpeg.cabal])

AC_CONFIG_HEADERS([src/config.h])

PKG_CHECK_MODULES(avformat, [libavformat >= 56 libavformat < 57],
 [
        CFLAGS="${CFLAGS} ${avformat_CFLAGS}"
        LDFLAGS="${LDFLAGS} ${avformat_LIBS}"
        AC_CHECK_HEADERS(libavformat/avformat.h ffmpeg/avformat.h)
 ],
 [
        AC_MSG_ERROR([Could not find AVFormat library])
 ])

PKG_CHECK_MODULES(avcodec, [libavcodec >= 56 libavcodec < 57],
 [
        CFLAGS="${CFLAGS} ${avcodec_CFLAGS}"
        LDFLAGS="${LDFLAGS} ${avcodec_LIBS}"
        AC_CHECK_HEADERS(libavcodec/avcodec.h ffmpeg/avcodec.h)
 ],
 [
        AC_MSG_ERROR([Could not find AVCodec library])
 ])

PKG_CHECK_MODULES(swscale, [libswscale >= 3 libswscale < 4],
 [
        CFLAGS="${CFLAGS} ${swscale_CFLAGS}"
        LDFLAGS="${LDFLAGS} ${swscale_LIBS}"
        AC_CHECK_HEADERS(libswscale/swscale.h ffmpeg/swscale.h)
 ],
 [
        AC_MSG_ERROR([Could not find SWScale library])
 ])

PKG_CHECK_MODULES(avutil, [libavutil >= 54 libavutil < 55],
 [
        CFLAGS="${CFLAGS} ${avutil_CFLAGS}"
        LDFLAGS="${LDFLAGS} ${avutil_LIBS}"
        AC_CHECK_HEADERS(libavutil/avutil.h ffmpeg/avutil.h)
 ],
 [
        AC_MSG_ERROR([Could not find AVUtil library])
 ])

dnl
dnl Check other libraries
dnl

dnl Vorbis checks
PKG_CHECK_MODULES(vorbisfile, [vorbisfile], 
                  [LDFLAGS="${LDFLAGS} ${vorbisfile_LIBS}"])
PKG_CHECK_MODULES(vorbis, [vorbis], 
                  [LDFLAGS="${LDFLAGS} ${vorbis_LIBS}"])
PKG_CHECK_MODULES(vorbisenc, [vorbisenc], 
                  [LDFLAGS="${LDFLAGS} ${vorbisenc_LIBS}"])

dnl Theora
PKG_CHECK_MODULES(theora, [theora], 
                  [LDFLAGS="${LDFLAGS} ${theora_LIBS}"])

dnl lame
AC_CHECK_LIB(mp3lame, lame_init, [LDFLAGS="${LDFLAGS} -lmp3lame"])

dnl faac
AC_CHECK_LIB(faac, faacEncGetVersion, [LDFLAGS="${LDFLAGS} -lfaac"])

dnl z
AC_CHECK_LIB(z, zlibVersion, [LDFLAGS="${LDFLAGS} -lz"])

dnl dc1394_control
PKG_CHECK_MODULES(libdc1394_2, [libdc1394-2], 
                  [LDFLAGS="${LDFLAGS} ${libdc1394_2_LIBS}"])

AC_SUBST([CFLAGS])
AC_SUBST([LDFLAGS])

AC_CONFIG_FILES([hs-ffmpeg.buildinfo])
AC_OUTPUT
