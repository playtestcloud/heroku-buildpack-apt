#!/usr/bin/env bash

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile() {
  cat > ${BUILD_DIR}/Aptfile <<EOF
ffmpeg=7:3.2.4-1build2
libxinerama1
libxcursor1
libxi6
libxrandr2
libxdamage1
libxfixes3
libsndfile1
libsndfile1-dev
libpng++-dev
libpng12-0
libboost-program-options-dev
git
libsodium18
libsodium-dev
gir1.2-freedesktop
gir1.2-rsvg-2.0
gir1.2-gdkpixbuf-2.0
gir1.2-glib-2.0
libgirepository-1.0-1
libgirepository1.0-dev
EOF

  compile

  assertCapturedSuccess

  assertCaptured "Fetching .debs for ffmpeg"
  assertCaptured "Installing ffmpeg_"
  assertCaptured "Installing libavcodec57_"
  assertCaptured "Installing libavdevice57_"
  assertCaptured "Installing libavfilter6_"
  assertCaptured "Installing libavformat57_"
  assertCaptured "Installing libva1_"
  assertCaptured "Fetching .debs for git"
}

testCompileFails() {
  cat > ${BUILD_DIR}/Aptfile <<EOF
thisdependencydoesnotexist
EOF

  compile

  assertNotEquals 0 "${RETURN}"
  assertContains "E: Unable to locate package thisdependencydoesnotexist" "$(cat ${STD_ERR})"
}
