#!/bin/sh

#
# Here we create empty xcconfig files if they do not exist.  Otherwise,
# the build will fail.
#
configs='Debug Release'
for config in $configs
do
   if [ ! -f $TOPLEVEL/mac/$config.xcconfig ]
   then 
      touch $TOPLEVEL/mac/$config.xcconfig
   fi
done

#
# Generate the header file for preprocessing the Info.plist
#
# It's also used for create the distribution files
#
cd ${TOPLEVEL}
mkdir -p mac/build
eval $(g++ -Wno-deprecated -stdlib=libc++ -E -dM src/Audacity.h | awk '/#define *AUDACITY_(VERSION|RELEASE|REVISION|MODLEVEL) /{print $2 "=" $3}')
case $CONFIGURATION in
Debug|Debug64)
    AUDACITY_EXECUTABLE=Wrapper;;
*)
    AUDACITY_EXECUTABLE=Wrapper;;
esac
cat >mac/build/Info.plist.h <<EOF
#define AUDACITY_EXECUTABLE ${AUDACITY_EXECUTABLE}
#define AUDACITY_VERSION ${AUDACITY_VERSION}
#define AUDACITY_RELEASE ${AUDACITY_RELEASE}
#define AUDACITY_REVISION ${AUDACITY_REVISION}
#define AUDACITY_DIST_VERSION ${AUDACITY_VERSION}.${AUDACITY_RELEASE}.${AUDACITY_REVISION}
#define AUDACITY_INFO_VERSION ${AUDACITY_VERSION}.${AUDACITY_RELEASE}.${AUDACITY_REVISION}.${AUDACITY_MODLEVEL}
EOF

exit 0
