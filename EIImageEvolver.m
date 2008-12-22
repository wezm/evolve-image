#import "EIImageEvolver.h"

@implementation EIImageEvolver : NSObject

- (id)initWithTargetImage:(NSString *)path
{
	if((self = [super init]) != nil)
	{
		target_image_path  = [path retain];
	}
	
	return self;
}

- (int)runWithThreads:(int)threads;
{
    NSMutableArray *mutable_dna = [[NSMutableArray alloc] initWithCapacity:threads];

    for(int i = 0; i < threads; i++)
    {
        EIDna *some_dna = [[EIDna alloc] initWithPolygons:NUM_POLYGONS
                                               withPoints:NUM_POLYGON_POINTS];
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
	if(target_image_path) [target_image_path release];
    
    [super dealloc];
}

@end
