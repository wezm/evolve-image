#import "EIDna.h"
#import "EIPolygon.h"
#import <string.h>
#import <math.h>

@implementation EIDna : NSObject

- (id)initWithPolygons:(int)num_polygons withPoints:(int)num_points
{
    if((self = [super init]) != nil) {
        NSMutableArray *mutable_polygons = [[NSMutableArray alloc] initWithCapacity:num_polygons];

        for(int i = 0; i < num_polygons; i++)
        {
            EIPolygon *polygon = [[EIPolygon alloc] initWithPoints:num_points];
            [mutable_polygons addObject:polygon];
            [polygon release];
        }
        polygons = mutable_polygons;

        // Initialise the psuedo random number stream
		twister = [[EIMersenneTwister alloc] init];
    }

    return self;
}

- (void)mutate
{
    // TODO: Replace this with a category on NSArray that returns a random object?
    int polygon_index = lround([twister nextValue] * ([polygons count] - 1));
    double roulette = [twister nextValue] * 2 ;
	
    EIPolygon *polygon = [polygons objectAtIndex:polygon_index];

    if(roulette < 1)
    {
		double new_value = [twister nextValue]; // Returns {0, 1}
		EIColor *color = [polygon color];
        if(roulette < 0.25)
        {
                // red
                NSLog(@"mutate polygon %d red", polygon_index);
                color->red = new_value;
		}
		else if(roulette < 0.5)
		{
                // green
                NSLog(@"mutate polygon %d green", polygon_index);
                color->green = new_value;
		}
		else if(roulette < 0.75)
		{
                // blue
                NSLog(@"mutate polygon %d blue", polygon_index);
                color->blue = new_value;
		}
		else
		{
                // alpha
                NSLog(@"mutate polygon %d alpha", polygon_index);
                color->alpha = new_value;
        }
    }
    else
    {
		int point_index = lround([twister nextValue] * ([polygon verticesCount] - 1));
		EIPoint *points = [polygon points];

		if(roulette < 1.5)
		{
			// X-coordinate
			int new_value = lround([twister nextValue] * ([target_image width] - 1));
			NSLog(@"mutate polygon %d point %d x to %d", polygon_index, point_index, new_value);
			points[point_index].x = new_value;
		}
		else
		{
			// Y-coordinate
			int new_value = lround([twister nextValue] * ([target_image height] - 1));
			NSLog(@"mutate polygon %d point %d y to %d", polygon_index, point_index, new_value);
			points[point_index].y = new_value;
		}
    }

}

- (NSString *)description
{
    EIPolygon *polygon;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSEnumerator *iter = [polygons objectEnumerator];
    NSMutableString *desc = [[NSMutableString alloc] initWithFormat:@"%d %d", [[polygons lastObject] verticesCount], [polygons count]];

    while((polygon = [iter nextObject]) != nil)
    {
        [desc appendFormat:@" %@", [polygon description]];
    }

    [pool release];
    return [desc autorelease];
}

- (void)dealloc
{
    if(polygons) [polygons release];
    if(twister) [twister release];
    [super dealloc];
}

@end
