#import "EIPolygon.h"

@implementation EIPolygon : NSObject

- (id)initWithPoints:(int)num_points
{
    if((self = [super init]) != nil)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSMutableArray *mutable_points = [[NSMutableArray alloc] initWithCapacity:num_points];
        for(int i = 0; i < num_points; i++)
        {
            NSValue *point = [NSValue valueWithPoint:NSMakePoint(0,0)];
            [mutable_points addObject:point];
        }
        points = mutable_points;
        color = [[EIColor alloc] init];
        [pool release];
    }

    return self;
}

- (int)verticesCount
{
    return [points count];
}

- (EIColor *)color
{
    return color;
}

- (NSString *)description
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableString *desc = [[NSMutableString alloc] initWithFormat:@"%@", color];
    NSEnumerator *iter = [points objectEnumerator];
    NSPoint point;
    NSValue *value;

    while((value = [iter nextObject]) != nil)
    {
        point = [value pointValue];
        [desc appendFormat:@" %d %d", point.x, point.y];
    }

    [pool release];
    return [desc autorelease];
}

- (void)dealloc
{
    if(points) [points release];
    [super dealloc];
}

@end
