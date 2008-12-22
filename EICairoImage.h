#import <Foundation/Foundation.h>
#import "EIImage.h"
#import <cairo.h>

@interface EICairoImage : EIImage {
	cairo_surface_t *surface;
}

@end
