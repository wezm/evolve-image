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

/*
function mutateDNA(dna_out) {
    CHANGED_SHAPE_INDEX = rand_int(MAX_SHAPES-1);
    
    var roulette = rand_float(2.0);
    
    // mutate color
    if(roulette<1) {
        // red
        if(roulette<0.25) {
            dna_out[CHANGED_SHAPE_INDEX].color.r = rand_int(255);
        }
        // green
        else if(roulette<0.5) {
            dna_out[CHANGED_SHAPE_INDEX].color.g = rand_int(255);
        }
        // blue
        else if(roulette<0.75) {
            dna_out[CHANGED_SHAPE_INDEX].color.b = rand_int(255);
        }
        // alpha
        else if(roulette<1.0) {
            dna_out[CHANGED_SHAPE_INDEX].color.a = rand_float(1.0);
        }
    }
    
    // mutate shape
    else {
        var CHANGED_POINT_INDEX = rand_int(MAX_POINTS-1);
        
        // x-coordinate
        if(roulette<1.5) {
            dna_out[CHANGED_SHAPE_INDEX].shape[CHANGED_POINT_INDEX].x = rand_int(IWIDTH);
        }
        
        // y-coordinate
        else {
            dna_out[CHANGED_SHAPE_INDEX].shape[CHANGED_POINT_INDEX].y = rand_int(IHEIGHT);
        }
    }
}
*/

- (void)mutate
{
    // TODO: Replace this with a category on NSArray that returns a random object?
    int polygon_index = lround([twister nextValue] * ([polygons count] - 1));
    double roulette = [twister nextValue] * 2 ;
	
    EIPolygon *polygon = [polygons objectAtIndex:polygon_index];

    if(roulette < 1)
    {
		double new_value = [twister nextValue];
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
		//         unsigned int point_index = rds_iuniform(rand_state, 0, [polygon verticesCount] - 1);
		// EIPoint *points = [polygon points];
		// 
		//         if(roulette < 1.5)
		//         {
		//             // X-coordinate
		// 	unsigned int new_value = rds_iuniform(rand_state, 0, [self width] - 1);
		//             NSLog(@"mutate polygon %d point %d x to %lf", polygon_index, point_index, new_value);
		// 	points[point_index].x = new_value;
		//         }
		//         else
		//         {
		//             // Y-coordinate
		// 	unsigned int new_value = rds_iuniform(rand_state, 0, [self height] - 1);
		//             NSLog(@"mutate polygon %d point %d y to %lf", polygon_index, point_index, new_value);
		// 	points[point_index].y = new_value;
		//         }
    }

}

- (int)width
{
	return width;
}

- (int)height
{
	return height;
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
