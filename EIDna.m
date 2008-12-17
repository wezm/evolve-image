#import "EIDna.h"
#import "EIPolygon.h"
#import "randistrs.h"
#import <string.h>

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
        rand_state = malloc(sizeof(mt_state));
        if(rand_state == NULL)
        {
            NSLog(@"Unable to allocte mt_state");
            [self release]; // XXX: is this valis here?
            return nil;
        }

        memset(rand_state, 0, sizeof(mt_state));
        mts_goodseed(rand_state);
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
    // TODO: Replace this with a category on NSArray that returns a rondom object?
    unsigned int polygon_index = rds_iuniform(rand_state, 0, [polygons count] - 1);
    unsigned int roulette = rds_iuniform(rand_state, 0, 7);
    EIPolygon *polygon = [polygons objectAtIndex:polygon_index];

    if(roulette < 4)
    {
        unsigned char new_value = rds_iuniform(rand_state, 0, 255);
        switch(roulette)
        {
            case 0:
                // red
                NSLog(@"mutate polygon %d red", polygon_index);
                [[polygon color] setRed:new_value];
                break;
            case 1:
                // green
                NSLog(@"mutate polygon %d green", polygon_index);
                [[polygon color] setGreen:new_value];
                break;
            case 2:
                // blue
                NSLog(@"mutate polygon %d blue", polygon_index);
                [[polygon color] setBlue:new_value];
                break;
            case 3:
                // alpha
                NSLog(@"mutate polygon %d alpha", polygon_index);
                [[polygon color] setAlpha:new_value];
                break;
            default:
                NSLog(@"Shouldn't get here %s:%d", __FILE__, __LINE__);
        }
    }
    else
    {
        unsigned int point_index = rds_iuniform(rand_state, 0, [polygon verticesCount] - 1);
        if(roulette < 6)
        {
            // X-coordinate
            NSLog(@"mutate polygon %d point %d x", polygon_index, point_index);
        }
        else
        {
            // Y-coordinate
            NSLog(@"mutate polygon %d point %d y", polygon_index, point_index);
        }
    }

}

- (unsigned int)randIntUpto:(unsigned int)max
{
    //int rand = rand();
    return 0;
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
    if(rand_state) free(rand_state);
    [super dealloc];
}

@end
