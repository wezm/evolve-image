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
- (int)stride;
- (cairo_format_t)format;
- (NSString *)formatString;
- (unsigned char *)data;
- (long)difference:(EICairoImage *)other;
- (long)sum;
- (void)changeToFormat:(cairo_format_t)format;

@end

