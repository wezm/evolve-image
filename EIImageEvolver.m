#import "EIImageEvolver.h"
#import "EITypes.h"
#import "EIPolygon.h"

@implementation EIImageEvolver : NSObject

- (id)initWithTargetImage:(NSString *)path
{
    if((self = [super init]) != nil)
    {
        target_image = [[EICairoImage alloc] initWithPath:path];
    }

    return self;
}

- (int)runWithThreads:(int)threads;
{
    NSMutableArray *mutable_dna = [[NSMutableArray alloc] initWithCapacity:threads];
    EIBounds bounds;

    bounds.width = [target_image width];
    bounds.height = [target_image height];

    for(int i = 0; i < threads; i++)
    {
        // Create polygons for the DNA to manipulate
        NSMutableArray *polygons = [[NSMutableArray alloc] initWithCapacity:NUM_POLYGONS];
        for(int j = 0; j < NUM_POLYGONS; j++)
        {
            EIPolygon *polygon = [[EIPolygon alloc] initWithPoints:NUM_POLYGON_POINTS];
            [polygons addObject:polygon];
            [polygon release];
        }

        EIDna *some_dna = [[EIDna alloc] initWithPolygons:polygons withinBounds:bounds];
        [polygons release];
        [mutable_dna addObject:some_dna];
        [some_dna release];
    }
    dna = mutable_dna;

    [[dna lastObject] mutate]; // XXX

    return 0;
}

- (NSString *)description
{
    if(!dna) return @"Uninitialised Image Evolver";

    //NSMutableString *desc = [[NSMutableString alloc] init];
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    //EIDna *some_dna;

    //NSEnumerator *iter = [dna objectEnumerator];
    //while((some_dna = [iter nextObject]) != nil)
    //{
    //    [desc appendString:[some_dna description]];
    //}

    //[pool release];
    //return [desc autorelease];
    return [dna description];
}

- (void)dealloc
{
    if(dna) [dna release];
    if(target_image) [target_image release];
    
    [super dealloc];
}

@end
