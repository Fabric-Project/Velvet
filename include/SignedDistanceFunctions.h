//
//  SignedDistanceFunctions.swift
//  Satin
//
//  Created by Reza Ali on 10/27/24.
//

#ifndef SignedDistanceFunctions_h
#define SignedDistanceFunctions_h

#import <simd/simd.h>

#if defined(__cplusplus)
extern "C" {
#endif

float lineSDF(simd_float3 pos, simd_float3 a, simd_float3 b);

#if defined(__cplusplus)
}
#endif

#endif /* SignedDistanceFunctions_h */
