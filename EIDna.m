#import "EIDna.h"

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
    }

    return self;
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
    [super dealloc];
}

@end
