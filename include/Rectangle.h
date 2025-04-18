//
//  Rectangle.h
//  Satin
//
//  Created by Reza Ali on 12/2/22.
//

#ifndef Rectangle_h
#define Rectangle_h

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wquoted-include-in-framework-header"
#include "Types.h"
#pragma clang diagnostic pop

#if defined(__cplusplus)
extern "C" {
#endif

Rectangle createRectangle(void);

simd_float2 rectangleCorner(const Rectangle *a, int index);

Rectangle expandRectangle(Rectangle rect, simd_float2 pt);
Rectangle mergeRectangle(Rectangle a, Rectangle b);

void mergeRectangleInPlace(Rectangle *a, const Rectangle *b);
void expandRectangleInPlace(Rectangle *rect, const simd_float2 *pt);

bool rectangleContainsPoint(Rectangle rect, simd_float2 pt);
bool rectangleContainsRectangle(Rectangle a, Rectangle b);
bool rectangleIntersectsRectangle(Rectangle a, Rectangle b);

Rectangle projectBoundsToRectangle(Bounds a, simd_float4x4 transform);

#if defined(__cplusplus)
}
#endif

#endif /* Rectangle_h */
