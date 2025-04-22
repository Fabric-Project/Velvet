#!/bin/bash

#  BuildSatinCore.sh
#  Velvet
#
#  Created by Anton Marini on 4/21/25.
#  

set -e

SRC_DIR="${SRCROOT}/../Satin/Sources/SatinCore"
ARTIFACT_DIR="${BUILD_DIR}/SatinArtifacts/${CONFIGURATION}"
INSTALL_NAME="@rpath/libSatinCore.dylib"
OUTPUT_DYLIB="${ARTIFACT_DIR}/libSatinCore.dylib"

mkdir -p "${ARTIFACT_DIR}"

clang++ \
  -std=c++17 \
  -dynamiclib \
  -install_name "${INSTALL_NAME}" \
  -o "${OUTPUT_DYLIB}" \
  $(find "${SRC_DIR}" -name "*.mm") \
  -I "${SRC_DIR}/include"

MODULE_MAP_SRC="module SatinCore [system] {\
umbrella header \"include/SatinCore.h\"\
export *\
}\
"
MODULE_MAP_DST="${ARTIFACT_DIR}/module.modulemap"
echo "${MODULE_MAP_SRC}" > "${MODULE_MAP_DST}"


INCLUDE_DIR_SRC="${SRCROOT}/../Satin/Sources/SatinCore/include/"
INCLUDE_DIR_DST="${ARTIFACT_DIR}/include"
cp -r "${INCLUDE_DIR_SRC}" "${INCLUDE_DIR_DST}"

echo "✅ Built libSatinCore.dylib → ${OUTPUT_DYLIB}"
