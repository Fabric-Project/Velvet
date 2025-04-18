//
//  Bounds.h
//  Satin
//
//  Created by Reza Ali on 11/30/20.
//

#ifndef Bounds_h
#define Bounds_h

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#include "Types.h"
#pragma clang diagnostic pop

#if defined(__cplusplus)
extern "C" {
#endif

Bounds createBounds(void);

Bounds computeBoundsFromFloatData(const void *data, int stride, int count);
Bounds computeBoundsFromVertices(const SatinVertex *vertices, int count);
Bounds computeBoundsFromVerticesAndTransform(
    const SatinVertex *vertices, int count, simd_float4x4 transform);

Bounds expandBounds(Bounds bounds, simd_float3 pt);
Bounds mergeBounds(Bounds a, Bounds b);
Bounds transformBounds(Bounds a, simd_float4x4 transform);

bool isPointInsideBounds(simd_float3 pt, Bounds b);
bool isPointInsideOrOnBounds(simd_float3 pt, Bounds b);

bool boundsIntersectsBounds(Bounds a, Bounds b);
bool boundsContainsBounds(Bounds a, Bounds b);

simd_float4 boundsCorner(Bounds a, int index);

void mergeBoundsInPlace(Bounds *a, const Bounds *b);
void expandBoundsInPlace(Bounds *bounds, const simd_float3 *pt);

#if defined(__cplusplus)
}
#endif

#endif /* Bounds_h */
