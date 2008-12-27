#import "EIDna.h"
#import "EIPolygon.h"
#import "EIMersenneTwister.h"
#import "EIRand.h"
#import <string.h>
#import <math.h>

@implementation EIDna : NSObject

- (id)initWithPolygons:(NSArray *)dna_polygons withinBounds:(EIBounds)dna_bounds;
{
    if((self = [super init]) != nil) {

        // Initialise the psuedo random number stream
        twister = [[EIMersenneTwister alloc] init];
        if(!twister)
        {
            NSLog(@"Unable to initialise Mersenne Twister, falling back on rand()");
            twister = [[EIRand alloc] init];
        }

        polygons = [dna_polygons retain];
        bounds = dna_bounds;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	// deep copy polygons
	NSMutableArray *polygons_copy = [[NSMutableArray alloc] initWithCapacity:[[self polygons] count]];
	NSEnumerator *iter = [[self polygons] objectEnumerator];
	EIPolygon *polygon;
	while((polygon = [iter nextObject]) != nil)
	{
		EIPolygon *polygon_copy = [polygon copy];
		[polygons_copy addObject:polygon_copy];
		[polygon_copy release];
	}
	EIDna *copy = [[[self class] allocWithZone:zone] initWithPolygons:polygons_copy withinBounds:[self bounds]];
	[polygons_copy release];
	
	return copy;
}

- (void)setIndex:(int)dna_index
{
	index = dna_index;
}
- (int)index
{
	return index;
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
                // NSLog(@"mutate polygon %d red to %lf", polygon_index, new_value);
                color->red = new_value;
		}
		else if(roulette < 0.5)
		{
                // green
                // NSLog(@"mutate polygon %d green to %lf", polygon_index, new_value);
                color->green = new_value;
		}
		else if(roulette < 0.75)
		{
                // blue
                // NSLog(@"mutate polygon %d blue to %lf", polygon_index, new_value);
                color->blue = new_value;
		}
		else
		{
                // alpha
                // NSLog(@"mutate polygon %d alpha to %lf", polygon_index, new_value);
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
			int new_value = lround([twister nextValue] * bounds.width);
			// NSLog(@"mutate polygon %d point %d x to %d", polygon_index, point_index, new_value);
			points[point_index].x = new_value;
		}
		else
		{
			// Y-coordinate
			int new_value = lround([twister nextValue] * bounds.height);
			// NSLog(@"mutate polygon %d point %d y to %d", polygon_index, point_index, new_value);
			points[point_index].y = new_value;
		}
    }

}

- (EIBounds)bounds
{
	return bounds;
}

- (NSArray *)polygons
{
	return polygons;
}

- (void)randomisePolygons
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSEnumerator *iter = [polygons objectEnumerator];
	EIPolygon *polygon;
	while((polygon = [iter nextObject]) != nil)
	{
		EIPoint *points = [polygon points];
		for(int i = 0; i < [polygon verticesCount]; i++)
		{
			points[i].x = lround([twister nextValue] * bounds.width);
			points[i].y = lround([twister nextValue] * bounds.height);
		}
	}
	
	[pool release];
}

- (NSString *)description
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSEnumerator *iter = [polygons objectEnumerator];
    EIPolygon *polygon;
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
