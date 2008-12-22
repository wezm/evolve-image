#import "EICairoImage.h"

@implementation EICairoImage : NSObject

- (id)initWithBounds:(EIBounds)bounds
{
    cairo_surface_t *cairo_surface = cairo_image_surface_create(
        CAIRO_FORMAT_ARGB32,
        bounds.width,
        bounds.height
    );
    return [self initWithSurface:cairo_surface];
}

- (id)initWithSurface:(cairo_surface_t *)cairo_surface
{
    if((self = [super init]) != nil)
    {
        //cairo_surface_reference(cairo_surface);
        surface = cairo_surface;
    }

    return self;
}


- (int)width
{
    return cairo_image_surface_get_width(surface);
}

- (int)height
{
    return cairo_image_surface_get_height(surface);
}

- (void)dealloc
{
	if(surface) cairo_surface_destroy(surface);
	[super dealloc];
}

@end

