#import "EICairoDnaPainter.h"

@implementation EICairoDnaPainter : NSObject

- (id)initWithDna:(EIDna *)new_dna
{
	if((self = [super init]) != nil)
	{
		dna = [new_dna retain];
		EIBounds bounds = [dna bounds];
		cairo_surface_t *surface = cairo_image_surface_create(
			CAIRO_FORMAT_ARGB32,
			bounds.width,
			bounds.height
		);
		context = cairo_create(surface);
		cairo_surface_destroy(surface);
	}
	
	return self;
}

- (void)paint
{
	// Paint the polygons
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSEnumerator *iter = [[dna polygons] objectEnumerator];
	EIPolygon *polygon;
	EIBounds bounds = [dna bounds];
	
	while((polygon = [iter nextObject]) != nil)
	{
		EIColor *color = [polygon color];
		cairo_set_source_rgb(context, 1,1,1);
		cairo_rectangle(context, 0,0,bounds.width,bounds.height);
		cairo_fill(context);
		cairo_set_source_rgba(
			context,
			color->red,
			color->blue,
			color->green,
			color->alpha
			);
		[self paintPolygon:polygon];
	}
	
	[pool release];
}

- (void)paintPolygon:(EIPolygon *)polygon
{
	EIPoint *points = [polygon points];
	
	// XXX: Assumes there is at least one point
	cairo_move_to(context, points[0].x, points[0].y);
	for(int i = 1; i < [polygon verticesCount]; i++)
	{
		EIPoint point = points[i];
		cairo_line_to(context, points[i].x, points[i].y);
	}
	cairo_close_path(context);
	cairo_fill(context);
}

- (void)writeToPNG:(NSString *)path
{
    cairo_surface_t *surface = cairo_get_target(context);
    cairo_status_t status = cairo_surface_write_to_png(surface, [path UTF8String]);
    if(status != CAIRO_STATUS_SUCCESS)
    {
        const char *status_string = cairo_status_to_string(status);
        if(!status_string)
        {
            status_string = "Unknown";
        }
        NSLog(@"Error writing to PNG file: %s", status_string);
    }
}

- (void)dealloc
{
	if(dna) [dna release];
	if(context) cairo_destroy(context);
	[super dealloc];
}

@end

