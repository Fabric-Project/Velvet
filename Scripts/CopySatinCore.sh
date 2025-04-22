#!/bin/bash

#  CopySatinCore.sh
#  Velvet
#
#  Created by Anton Marini on 4/21/25.
#  

mkdir -p "${BUILD_DIR}/${CONFIGURATION}/${PRODUCT_NAME}.app/Contents/Shared Frameworks/"

SRC="${BUILD_DIR}/SatinArtifacts/${CONFIGURATION}/"
DST="${BUILD_DIR}/${CONFIGURATION}/${PRODUCT_NAME}.app/Contents/Shared Frameworks/"

cp -r "${SRC}" "${DST}"


mkdir -p "${BUILD_DIR}/${CONFIGURATION}/${PRODUCT_NAME}.app/Contents/Resources/Pipelines/"

SRC="${SRCROOT}/../Satin/Sources/Satin/Pipelines/"
DST="${BUILD_DIR}/${CONFIGURATION}/${PRODUCT_NAME}.app/Contents/Resources/Pipelines/"

cp -r "${SRC}" "${DST}"
