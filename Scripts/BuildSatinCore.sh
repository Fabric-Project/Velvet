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

echo "✅ Built libSatinCore.dylib → ${OUTPUT_DYLIB}"
