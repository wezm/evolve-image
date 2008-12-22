#import "EICairoImage.h"

@implementation EICairoImage : EIImage

- (id)initWithPath:(NSString *)image_path
{
	if((self = [super init]) != nil)
	{
		surface = cairo_image_surface_create_from_png([[self path] UTF8String]);
	}
	
	return self;
}

- (void)dealloc
{
	if(surface) cairo_surface_destroy(surface);
	[super dealloc];
}

@end
