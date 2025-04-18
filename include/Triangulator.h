//
//  Triangulator.h
//  Satin
//
//  Created by Reza Ali on 7/5/20.
//

#ifndef Triangulator_h
#define Triangulator_h

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#include "Types.h"
#pragma clang diagnostic pop

#if defined(__cplusplus)
extern "C" {
#endif

int triangulatePolylines(
    Polylines2D *lines, GeometryData *geometryData, TriangleData *triangleData);

// triangulates multiple paths
int triangulate(simd_float2 **paths, int *lengths, int count, TriangleData *gData);

// triangulates one counter clockwise path
int triangulatePath(simd_float2 *points, int length, TriangleData *gData);

int extrudePaths(simd_float2 **paths, int *lengths, int count, GeometryData *gData);

#if defined(__cplusplus)
}
#endif

#endif /* Triangulator_h */
