#import "EIPolygon.h"
#import <string.h>

@implementation EIPolygon : NSObject

- (id)initWithPoints:(int)num_points
{
    if((self = [super init]) != nil)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		points = calloc(num_points, sizeof(EIPoint));
		if(points == NULL)
		{
			NSLog(@"Unable to allocate points");
			[self release];
			return nil;
		}

		color = malloc(sizeof(EIColor));
		if(color == NULL)
		{
			NSLog(@"Unable to allocate color of polygon");
			[self release];
			return nil;
		}
		memset(color, 0, sizeof(EIColor)); // Init color to almost invisible
		color->alpha = 0.001;
		points_count = num_points;
        [pool release];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	EIPolygon *copy = [[[self class] allocWithZone:zone] initWithPoints:[self verticesCount]];
	
	[copy setPoints:[self points]];
	[copy setColor:[self color]];
	
	return copy;
}

- (int)verticesCount
{
    return points_count;
}

- (EIColor *)color
{
    return color;
}

- (void)setColor:(EIColor *)new_color
{
	*color = *new_color;
}

- (EIPoint *)points
{
    return points;
}

- (void)setPoints:(EIPoint *)new_points
{
	// Assumes the same number of points that this instance was
	// initialised with
	memcpy(points, new_points, sizeof(EIPoint) * [self verticesCount]);
}

- (NSString *)description
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableString *desc = [[NSMutableString alloc] initWithFormat:@"%lf %lf %lf %lf",
		color->red, color->green, color->blue, color->alpha];
    EIPoint point;

	for(int i = 0; i < points_count; i++)
    {
		point = points[i];
        [desc appendFormat:@" %lf %lf", point.x, point.y];
    }

    [pool release];
    return [desc autorelease];
}

- (void)dealloc
{
    if(points) free(points);
	if(color) free(color);
    [super dealloc];
}

@end
