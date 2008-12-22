#import "EIImageEvolver.h"
#import "EITypes.h"
#import "EIPolygon.h"
#import "EICairoDnaPainter.h"

@implementation EIImageEvolver : NSObject

- (id)initWithTargetImage:(NSString *)path
{
    if((self = [super init]) != nil)
    {
        target_image = [[EICairoPNGImage alloc] initWithPath:path];
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

	NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(evolveWithDna:) object:[dna lastObject]];
	//[NSThread detachNewThreadSelector:@selector(evolveWithDna:) toTarget:self withObject:[dna lastObject]];

	[thread start];
	NSLog(@"Waiting");
	for(int i = 1; i <= 5; i++)
	{
		// [NSThread sleepForTimeInterval:1];
		sleep(1);
		NSLog(@"%d", i);
	}
	[thread cancel];

	while(![thread isFinished]);

    return 0;
}

- (void)evolveWithDna:(EIDna *)helix
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EIBounds bounds;
    bounds.width = [target_image width];
    bounds.height = [target_image height];
	EICairoDnaPainter *painter = [[EICairoDnaPainter alloc] initWithDna:helix];

	unsigned int mutation_count = 0;
	while(![[NSThread currentThread] isCancelled])
	{
		[helix mutate];
		[painter paint];
		//[self measureFitness]
		mutation_count++;
	}
	NSLog(@"%u mutations", mutation_count);
	
	[painter writeToPNG:@"/Users/wmoore/Desktop/out.png"];
	[painter release];
	
	[pool release];
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
