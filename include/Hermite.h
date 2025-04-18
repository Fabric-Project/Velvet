//
//  Hermite.h
//
//
//  Created by Reza Ali on 5/4/23.
//

#ifndef Hermite_h
#define Hermite_h

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#include "Types.h"
#pragma clang diagnostic pop

#if defined(__cplusplus)
extern "C" {
#endif

simd_float3 hermite3(simd_float3 m0, simd_float3 a, simd_float3 b, simd_float3 m1, float t);

#if defined(__cplusplus)
}
#endif

#endif /* Hermite_h */
