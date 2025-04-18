//
//  Geometry.h
//  Satin
//
//  Created by Reza Ali on 6/28/20.
//

#ifndef Geometry_h
#define Geometry_h

#import <stdio.h>
#import <stdbool.h>
#import <simd/simd.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#include "Types.h"
#pragma clang diagnostic pop

#if defined(__cplusplus)
extern "C" {
#endif

bool greaterThanZero(float a);
bool isZero(float a);
bool isZeroDouble(double a);

float area2(simd_float2 a, simd_float2 b, simd_float2 c);
float cross2(simd_float2 a, simd_float2 b);
bool isLeft(simd_float2 a, simd_float2 b, simd_float2 c);
bool isLeftOn(simd_float2 a, simd_float2 b, simd_float2 c);

bool inCone(simd_float2 a0, simd_float2 a, simd_float2 a1, simd_float2 b);

bool isEqual(float a, float b);
bool isEqual2(simd_float2 a, simd_float2 b);

bool isDiagonalInPolygon(simd_float2 a, simd_float2 b, const simd_float2 *polygon, int count);
bool isDiagonalInOrOnPolygon(simd_float2 a, simd_float2 b, const simd_float2 *polygon, int count);
bool isDiagonal(int i, int j, const simd_float2 *polygon, int count);

bool isClockwise(const simd_float2 *polygon, int length);

bool isColinear2(simd_float2 a, simd_float2 b, simd_float2 c);
bool isColinear3(simd_float3 a, simd_float3 b, simd_float3 c);

bool isConvex(const simd_float2 *path, int length);

bool isBetween(simd_float2 a, simd_float2 b, simd_float2 c);

bool intersectsProper(simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d);
bool intersectsProperOrInBetween(simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d);

bool lineLineIntersection2(
    simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d, simd_float2 *intersection);
bool lineLineDistance3(
    simd_float3 a,
    simd_float3 b,
    simd_float3 c,
    simd_float3 d,
    simd_float3 *ab,
    simd_float3 *cd,
    float *mab,
    float *mcd);

bool rayRayIntersection2(
    simd_float2 as, simd_float2 ad, simd_float2 bs, simd_float2 bd, simd_float2 *intersection);

bool rayPlaneIntersection(
    simd_float3 origin,
    simd_float3 direction,
    simd_float3 planeNormal,
    simd_float3 planeOrigin,
    simd_float3 *intersection);

bool rayPlaneIntersectionTime(
    simd_float3 origin,
    simd_float3 direction,
    simd_float3 planeNormal,
    simd_float3 planeOrigin,
    float *time);

bool rayBoundsIntersection(
    simd_float3 origin, simd_float3 direction, Bounds bounds, simd_float2 *times);

bool rayBoundsIntersection(
    simd_float3 origin, simd_float3 direction, Bounds bounds, simd_float2 *times);

bool rayBoundsIntersect(Ray ray, Bounds bounds);

bool raySphereIntersection(
    simd_float3 origin,
    simd_float3 direction,
    simd_float3 center,
    float radius,
    simd_float2 *times);

bool rayTriangleIntersection(
    simd_float3 origin,
    simd_float3 direction,
    simd_float3 v0,
    simd_float3 v1,
    simd_float3 v2,
    float *time,
    simd_float3 *intersection,
    simd_float3 *normal);

bool rayTriangleIntersectionTime(
    Ray ray, simd_float3 p0, simd_float3 p1, simd_float3 p2, float *time);

bool rayTriangleIntersect(
    simd_float3 origin,
    simd_float3 direction,
    simd_float3 v0,
    simd_float3 v1,
    simd_float3 v2,
    float *time,
    simd_float3 *intersection,
    simd_float3 *normal,
    simd_float3 *bc);

simd_float3 projectPointOnPlane(simd_float3 origin, simd_float3 normal, simd_float3 point);
float pointPlaneDistance(simd_float3 origin, simd_float3 normal, simd_float3 point);
simd_float2 projectedPointOnLine2(simd_float2 start, simd_float2 end, simd_float2 point);

float pointLineDistance2(simd_float2 start, simd_float2 end, simd_float2 point);
float pointLineDistance3(simd_float3 start, simd_float3 end, simd_float3 point);
simd_float3 closestPointOnLine3(simd_float3 start, simd_float3 end, simd_float3 point);

float angle2(simd_float2 a);
float angle(float x, float y);

simd_float3 getBarycentricCoordinates(simd_float3 p, simd_float3 a, simd_float3 b, simd_float3 c);

#if defined(__cplusplus)
}
#endif

#endif /* Geometry_h */
