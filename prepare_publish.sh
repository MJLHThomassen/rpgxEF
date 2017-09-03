#!/bin/bash

RELEASES=(linux_x86 linux_x64 windows_x86 windows_x64)

OSS=(linux linux mingw32 mingw32)
ARCHS=(x86 x86_64 x86 x86_64)
EXES=("" "" .exe .exe)
DLLS=(.so .so .dll .dll)

BUILDMODE=release
PUBDIR=publish

# Create Publish Directory
mkdir -p $PUBDIR

# Loop trough all releases
for i in ${!RELEASES[@]}; do 

	# Set correct variable values for this release
	RELEASE=${RELEASES[$i]}
	OS=${OSS[$i]}
	ARCH=${ARCHS[$i]}
	EXE=${EXES[$i]}
	DLL=${DLLS[$i]}
	BINDIR=build/$BUILDMODE-$OS-$ARCH

	# Define files required for this release
	ROOTFILES=(rpgxEF.$ARCH$EXE rpgxEFded.$ARCH$EXE renderer_opengl1_$ARCH$DLL)
	RPGX2FILES=(rpgxEF/cgame$ARCH$DLL rpgxEF/qagame$ARCH$DLL rpgxEF/ui$ARCH$DLL)
	
	# Create inner publish dirs
	mkdir -p $PUBDIR/$RELEASE
	mkdir -p $PUBDIR/$RELEASE/RPG-X2

	SKIP=false
	for FILE in ${ROOTFILES[@]}; do
		if [ -f $BINDIR/$FILE ]; then	   
			cp -f $BINDIR/$FILE $PUBDIR/$RELEASE/
		else
		   echo "File $FILE does not exist"
		   SKIP=true
		   break
		fi
	done
	
	for FILE in ${RPGX2FILES[@]}; do
		if [ -f $BINDIR/$FILE ]; then	   
			cp -f $BINDIR/$FILE $PUBDIR/$RELEASE/RPG-X2/
		else
		   echo "File $FILE does not exist"
		   SKIP=true
		   break
		fi
	done
	
	if [ $SKIP = true ]; then
		rm -rf $PUBDIR/$RELEASE
		echo "Skipping zip creation for $BUILDMODE-$OS-$ARCH"
		continue
	fi
	
	# Zip the binaries for easy distribution
	pushd $PUBDIR/$RELEASE/
	zip -r ../$RELEASE.zip ./
	popd

done
