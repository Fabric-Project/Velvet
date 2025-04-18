//
//  Bezier.h
//  Satin
//
//  Created by Reza Ali on 6/28/20.
//

#ifndef Bezier_h
#define Bezier_h

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#include "Types.h"
#pragma clang diagnostic pop

#if defined(__cplusplus)
extern "C" {
#endif

Polyline2D createEmptyPolyline2D(void);
Polylines2D createEmptyPolylines2D(void);

void freePolyline2D(Polyline2D *line);
void freePolylines2D(Polylines2D *lines);

Polyline3D createEmptyPolyline3D(void);
Polylines3D createEmptyPolylines3D(void);

void freePolyline3D(Polyline3D *line);
void freePolylines3D(Polylines3D *lines);

void addPointToPolyline2D(simd_float2 p, Polyline2D *line);
void removeFirstPointInPolyline2D(Polyline2D *line);
void removeLastPointInPolyline2D(Polyline2D *line);
void appendPolyline2D(Polyline2D *dst, Polyline2D *src);

void addPointToPolyline3D(simd_float3 p, Polyline3D *line);
void removeFirstPointInPolyline3D(Polyline3D *line);
void removeLastPointInPolyline3D(Polyline3D *line);
void appendPolyline3D(Polyline3D *dst, Polyline3D *src);

Polyline2D getLinearPath2(simd_float2 a, simd_float2 b, int res);
Polyline2D getAdaptiveLinearPath2(simd_float2 a, simd_float2 b, float distanceLimit);

simd_float2 quadraticBezier2(simd_float2 a, simd_float2 b, simd_float2 c, float t);
simd_float2 quadraticBezierVelocity2(simd_float2 a, simd_float2 b, simd_float2 c, float t);
simd_float2 quadraticBezierAcceleration2(simd_float2 a, simd_float2 b, simd_float2 c, float t);
float quadraticBezierCurvature2(simd_float2 a, simd_float2 b, simd_float2 c, float t);

Polyline2D getQuadraticBezierPath2(simd_float2 a, simd_float2 b, simd_float2 c, int res);
Polyline2D
getAdaptiveQuadraticBezierPath2(simd_float2 a, simd_float2 b, simd_float2 c, float angleLimit);

float cubicBezier1(float a, float b, float c, float d, float t);
simd_float2 cubicBezier2(simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d, float t);
simd_float2
cubicBezierVelocity2(simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d, float t);
simd_float2
cubicBezierAcceleration2(simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d, float t);
float cubicBezierCurvature2(simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d, float t);

Polyline2D getCubicBezierPath2(simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d, int res);
Polyline2D getAdaptiveCubicBezierPath2(
    simd_float2 a, simd_float2 b, simd_float2 c, simd_float2 d, float angleLimit);

simd_float3 quadraticBezier3(simd_float3 a, simd_float3 b, simd_float3 c, float t);
simd_float3 cubicBezier3(simd_float3 a, simd_float3 b, simd_float3 c, simd_float3 d, float t);
simd_float3
cubicBezierVelocity3(simd_float3 a, simd_float3 b, simd_float3 c, simd_float3 d, float t);
simd_float3
cubicBezierAcceleration3(simd_float3 a, simd_float3 b, simd_float3 c, simd_float3 d, float t);
simd_float3 cubicBezierJerk3(simd_float3 a, simd_float3 b, simd_float3 c, simd_float3 d, float t);
float cubicBezierCurvature3(simd_float3 a, simd_float3 b, simd_float3 c, simd_float3 d, float t);

Polyline3D getCubicBezierPath3(simd_float3 a, simd_float3 b, simd_float3 c, simd_float3 d, int res);
Polyline3D getAdaptiveCubicBezierPath3(
    simd_float3 a, simd_float3 b, simd_float3 c, simd_float3 d, float angleLimit);

Polyline3D convertPolyline2DToPolyline3D(Polyline2D *line);

#if defined(__cplusplus)
}
#endif

#endif /* Bezier_h */
