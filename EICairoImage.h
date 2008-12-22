#import <Foundation/Foundation.h>
#import "EIImage.h"
#import <cairo.h>

#ifndef CAIRO_HAS_PNG_FUNCTIONS
#error Cairo does not have required PNG support
#endif

@interface EICairoImage : EIImage {
	cairo_surface_t *surface;
}

@end
