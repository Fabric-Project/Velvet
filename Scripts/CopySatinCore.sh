#!/bin/bash

#  CopySatinCore.sh
#  Velvet
#
#  Created by Anton Marini on 4/21/25.
#  

SRC="${BUILD_DIR}/SatinArtifacts/${CONFIGURATION}/libSatinCore.dylib"
DST="${TARGET_BUILD_DIR}/${PRODUCT_NAME}.app/Contents/Shared Frameworks"

mkdir -p "${DST}"
cp -v "${SRC}" "${DST}"
