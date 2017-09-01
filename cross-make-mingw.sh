#!/bin/sh

CMD_PREFIX="i586-mingw32msvc i686-w64-mingw32";

if [ "X$CC" = "X" ]; then
    for check in $CMD_PREFIX; do
        full_check="${check}-gcc"
	if [ ! $(which "$full_check") = "" ]; then
	    export CC="$full_check"
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

for check in $CMD_PREFIX; do
    INCLUDE_DIR="/usr/${check}/include";
    if [ ! $PATH = *"$INCLUDE_DIR"* ] && [ -d "$INCLUDE_DIR" ] ; then
	    export PATH="$INCLUDE_DIR:$PATH"
    fi
done

if [ "X$WINDRES" = "X" -o "X$CC" = "X" ]; then
    echo "Error: Must define or find WINDRES and CC"
    exit 1
fi

export PLATFORM=mingw32
export ARCH=x86

echo $PATH
ls /usr
cat /usr/i686-w64-mingw32/include/windows.h

exec make $*
