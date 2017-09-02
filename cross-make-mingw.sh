#!/bin/sh

CMD_PREFIX="i586-mingw32msvc i686-w64-mingw32";
MINGW_VERSION="";

if [ "X$CC" = "X" ]; then
    for check in $CMD_PREFIX; do
        full_check="${check}-gcc"
	if [ ! $(which "$full_check") = "" ]; then
	    export CC="$full_check"
		MINGW_VERSION = ${check};
	fi
    done
fi

if [ "X$WINDRES" = "X" ]; then
    for check in $CMD_PREFIX; do
        full_check="${check}-windres"
	if [ ! $(which "$full_check") = "" ]; then
	    export WINDRES="$full_check"
	fi
    done
fi

CC_INCLUDE_DIR="";
INCLUDE_DIR="/usr/${MINGW_VERSION}/include";
if [ ! $PATH = *"$INCLUDE_DIR"* ] && [ -d "$INCLUDE_DIR" ] ; then
	export PATH="$INCLUDE_DIR:$PATH"
	export CC_INCLUDE_DIR="-I${INCLUDE_DIR}"
fi

if [ "X$WINDRES" = "X" -o "X$CC" = "X" ]; then
    echo "Error: Must define or find WINDRES and CC"
    exit 1
fi

export PLATFORM=mingw32
export ARCH=x86

echo ""
echo "PATH: "
echo $PATH

echo ""
echo "CC_INCLUDE_DIR"
echo $CC_INCLUDE_DIR

echo ""
echo "ls /usr: "
ls /usr

echo ""
echo "windows.h: "
cat ${INCLUDE_DIR}/windows.h

exec make $*
