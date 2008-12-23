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
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    cairo_status_t status;
    cairo_surface_t *surface = cairo_get_target(context);

    status = cairo_surface_status(surface);
    if(status != CAIRO_STATUS_SUCCESS)
    {
        const char *status_string = cairo_status_to_string(status);
        if(!status_string)
        {
            status_string = "Unknown";
        }
        NSLog(@"Surface is not OK: %s", status_string);
        [pool release];
        return;
    }


    NSFileHandle *png_handle = [NSFileHandle fileHandleForWritingAtPath:path];
    if(png_handle == nil)
    {
        NSLog(@"Unable to open %@ for writing", path);
        [pool release];
        return;
    }
    
    // Use the more complex cairo_write_to_png_stream so that the Foundation
    // file writing methods can be used as the cairo_write_to_png function had
    // problems writing to Windows UNC paths
    status = cairo_surface_write_to_png_stream(
        surface,
        write_png_data,
        png_handle
    );
    if(status != CAIRO_STATUS_SUCCESS)
    {
        const char *status_string = cairo_status_to_string(status);
        if(!status_string)
        {
            status_string = "Unknown";
        }
        NSLog(@"Error writing to PNG file: %s", status_string);
    }

    [pool release];
}

- (void)dealloc
{
	if(dna) [dna release];
	if(context) cairo_destroy(context);
	[super dealloc];
}

@end

// Callback for cairo_surface_write_to_png_stream
cairo_status_t write_png_data(void *closure, const unsigned char *data, unsigned int length)
{
    NSFileHandle *fh = (NSFileHandle *)closure;
    //NSData *png_data = [[NSData alloc] initWithBytesNoCopy:data length:length freeWhenDone:NO];
    // This will copy the data, which sucks but the other NSData initialisers
    // dont have the const restriction on the bytes argument
    NSData *png_data = [[NSData alloc] initWithBytes:data length:length];

    NSLog(@"write_png_data %u", length);
    [fh writeData:png_data];

    [png_data release];
    return CAIRO_STATUS_SUCCESS;
}

