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

- (int)stride
{
    return cairo_image_surface_get_stride(surface);
}

- (cairo_format_t)format
{
    return cairo_image_surface_get_format(surface);
}

- (NSString *)formatString
{
    NSString *format;
    switch([self format])
    {
        case CAIRO_FORMAT_ARGB32:
            format = @"CAIRO_FORMAT_ARGB32";
            break;
        case CAIRO_FORMAT_RGB24:
            format = @"CAIRO_FORMAT_RGB24";
            break;
        case CAIRO_FORMAT_A8:
            format = @"CAIRO_FORMAT_A8";
            break;
        case CAIRO_FORMAT_A1:
            format = @"CAIRO_FORMAT_A1";
            break;
        default:
            format = @"Unknown";
    }

    return format;
}

- (unsigned char *)data
{
    return cairo_image_surface_get_data(surface);
}

- (long)difference:(EICairoImage *)other
{
    if([self format] != [other format])
    {
        NSLog(@"images are in differing formats (%@ vs. %@), can't compare",
                [self formatString], [other formatString]);
        return 0;
    }

    if([self stride] != [other stride])
    {
        NSLog(@"differing strides");
        return 0;
    }

    if(([self width] != [other width]) || ([self height] != [other height]))
    {
        NSLog(@"Images are of different dimensions");
        return 0;
    }

    unsigned char *self_data = [self data];
    unsigned char *other_data = [other data];

    int offset = 0;
    long difference = 0;
    for(int y = 0; y < [self height]; y++)
    {
        for(int x = 0; x < [self width]; x++)
        {
            int index = offset + x;
            difference += abs(self_data[index] - other_data[index]);
        }
        offset += [self stride];
    }

    return difference;
}

- (long)sum
{
	long sum = 0;
    int offset = 0;
    unsigned char *self_data = [self data];

    for(int y = 0; y < [self height]; y++)
    {
        for(int x = 0; x < [self width]; x++)
        {
			sum += self_data[offset + x];
        }
        offset += [self stride];
    }

    return sum;
}

- (void)changeToFormat:(cairo_format_t)format
{
    // Attempts to convert the image from to the new format specified
    if([self format] == format) return; // No conversion necessary

    cairo_surface_t *new_surface = cairo_image_surface_create(
        format,
        [self width],
        [self height]
    );
    cairo_t *context = cairo_create(new_surface);
    cairo_set_source_surface(context, surface, 0, 0);
    cairo_paint(context);
    cairo_destroy(context);
    cairo_surface_destroy(surface);
    surface = new_surface;
}

- (void)dealloc
{
	if(surface) cairo_surface_destroy(surface);
	[super dealloc];
}

@end

