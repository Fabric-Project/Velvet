//
//  PoissonDiskSampler.h
//  Satin
//
//  Created by Reza Ali on 11/9/24.
//

#ifndef PoissonDiskSampler_h
#define PoissonDiskSampler_h

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#include "Types.h"
#pragma clang diagnostic pop

#if defined(__cplusplus)
extern "C" {
#endif

Points2D generatePoissonDiskSamples(Rectangle rect, float minDistance, float k);

#if defined(__cplusplus)
}
#endif

#endif /* PoissonDiskSampler_h */
