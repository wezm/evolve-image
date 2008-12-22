#import "EICairoPNGImage.h"

@implementation EICairoPNGImage : EICairoImage

- (id)initWithPath:(NSString *)image_path
{
    cairo_surface_t *cairo_surface = cairo_image_surface_create_from_png([image_path UTF8String]);
    return [super initWithSurface:cairo_surface];
}

@end

