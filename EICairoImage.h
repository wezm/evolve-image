#import <Foundation/Foundation.h>
#import <cairo.h>
#import "EITypes.h"

@interface EICairoImage : NSObject {
	cairo_surface_t *surface;
}

- (id)initWithBounds:(EIBounds)bounds;
- (id)initWithSurface:(cairo_surface_t *)cairo_surface;
- (int)width;
- (int)height;

@end

