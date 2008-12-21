#import "EIPolygon.h"

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
		points_count = num_points;
        [pool release];
    }

    return self;
}

- (int)verticesCount
{
    return points_count;
}

- (EIColor *)color
{
    return color;
}

- (EIPoint *)points
{
    return points;
}

- (NSString *)description
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableString *desc = [[NSMutableString alloc] initWithFormat:@"%@", color];
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
