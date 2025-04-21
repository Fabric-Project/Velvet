#!/bin/bash
set -e

SRCROOT="${SRCROOT}/../Satin/"
ARTIFACT_DIR="${BUILD_DIR}/SatinArtifacts/${CONFIGURATION}"

# Paths
SATINCORE_INCLUDE="${SRCROOT}/Sources/SatinCore/include"
SATIN_SRC_DIR="${SRCROOT}/Sources/Satin"
SATIN_DYLIB="${ARTIFACT_DIR}/libSatin.dylib"
SWIFTMODULE_DIR="${ARTIFACT_DIR}/Satin.swiftmodule"

# Create necessary output dirs
mkdir -p "${SWIFTMODULE_DIR}"

swiftc -v \
-emit-library \
-target arm64-apple-macos14.0 \
-module-name Satin \
$(find "${SATIN_SRC_DIR}" -name "*.swift") \
-I "${ARTIFACT_DIR}" \
-L "${ARTIFACT_DIR}" \
-lSatinCore \
-o "${SATIN_DYLIB}" \
-emit-module-path "${SWIFTMODULE_DIR}/arm64-apple-macos.swiftmodule" \
-emit-module-interface-path "${SWIFTMODULE_DIR}/arm64-apple-macos.swiftinterface" \
-Xlinker -rpath -Xlinker @loader_path \
-Xlinker -install_name -Xlinker @rpath/libSatin.dylib \
-Xcc -I"${SATINCORE_INCLUDE}" \
-Xcc -fmodule-map-file="${SATINCORE_INCLUDE}/SatinCore.modulemap" \
-DSWIFT_PACKAGE -j8 \
-framework Metal -framework MetalKit

echo "✅ Built libSatin.dylib → ${SATIN_DYLIB}"
