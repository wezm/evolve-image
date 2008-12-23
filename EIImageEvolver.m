#import "EIImageEvolver.h"
#import "EITypes.h"
#import "EIPolygon.h"
#import "EICairoDnaPainter.h"

#ifdef WIN32
#import <windows.h>
#else
#ifdef POSIX
#import <unistd.h>
#endif
#endif

// Determine how many CPUs/cores we have to available
unsigned int getProcessorCount()
{
    unsigned int processor_count = 0;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSProcessInfo *process_info = [NSProcessInfo processInfo];
    processor_count = [process_info processorCount];
    if(processor_count < 1)
    {
        // Fall back on platform specific methods
#ifdef WIN32
        SYSTEM_INFO system_info;
        GetSystemInfo(&system_info);
        processor_count = system_info.dwNumberOfProcessors;
#else
#ifdef POSIX
        // Hopefully this covers Linux (and Solaris?)
        int x = sysconf(_SC_NPROCESSORS_CONF);
        if(!(x < 0)) processor_count = x;
#endif
#endif
    }

    [pool release];
    NSLog(@"System has %u processors", processor_count);
    return processor_count;
}

@implementation EIImageEvolver : NSObject

- (id)init
{
    if((self = [super init]) != nil)
    {
        num_threads = getProcessorCount();
        if(num_threads < 1)
        {
            NSLog(@"Processor count less than 1, defaulting to 1");
            num_threads = 1;
        }
    }

    return self;
}

- (int)evolveToTargetImageAtPath:(NSString *)path;
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSMutableArray *mutable_dna = [[NSMutableArray alloc] initWithCapacity:num_threads];
    EIBounds bounds;

    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"Target image: %@ does not exist", path);
        return 1;
    }

    target_image = [[EICairoPNGImage alloc] initWithPath:path];
    bounds.width = [target_image width];
    bounds.height = [target_image height];

    for(int i = 0; i < num_threads; i++)
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

	NSMutableArray *threads = [[NSMutableArray alloc] init];
	NSEnumerator *iter = [dna objectEnumerator];
	EIDna *d;
	int i = 0;
	while((d = [iter nextObject]) != nil)
	{
		[d setIndex:i++];
	    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(evolveDna:) object:d];
		[threads addObject:thread];
		[thread release];
	}

	// Start the threads!
	[threads makeObjectsPerformSelector:@selector(start)];

    NSLog(@"Waiting");
    for(int i = 1; i <= 3; i++)
    {
        [NSThread sleepForTimeInterval:1];
        //sleep(1);
        NSLog(@"%d", i);
    }

	// Stop the threads
	[threads makeObjectsPerformSelector:@selector(cancel)];

	// Wait for them all to finish
	int unfinished = [threads count];
	while(unfinished != 0)
	{
		unfinished = 0;
		iter = [threads objectEnumerator];
		NSThread *thread;
		while((thread = [iter nextObject]) != nil)
		{
			if(![thread isFinished]) unfinished++;
		}
	}
    [threads release];
	[pool release];
    return 0;
}

- (void)evolveDna:(EIDna *)helix
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EIBounds bounds;
    bounds.width = [target_image width];
    bounds.height = [target_image height];
    EICairoDnaPainter *painter = [[EICairoDnaPainter alloc] initWithDna:helix];
    NSString *desktop;

    unsigned int mutation_count = 0;
    while(![[NSThread currentThread] isCancelled])
    {
        [helix mutate];
        [painter paint];
        //[self measureFitness]
        mutation_count++;
    }
    NSLog(@"%u mutations", mutation_count);

    // Try to find the Desktop dir
    NSArray *desktop_paths = NSSearchPathForDirectoriesInDomains(
        NSDesktopDirectory,
        NSUserDomainMask,
        YES
    );

    if([desktop_paths count] > 0)
    {
        desktop = [desktop_paths objectAtIndex:0];
    }
    else
    {
        NSLog(@"Unable to find user's Desktop, falling back on home dir");
        desktop = NSHomeDirectory();
    }

    NSFileManager *file_manager = [NSFileManager defaultManager];
    if(![file_manager fileExistsAtPath:desktop])
    {
        // Create the Desktop (most likely a Windows only thing)
        if(![file_manager createDirectoryAtPath:desktop attributes:nil])
        {
            NSLog(@"Unable to create Desktop: %@", desktop);
        }
    }

    NSString *output_path = [desktop stringByAppendingPathComponent:[NSString stringWithFormat:@"evolve%d.png", [helix index]]];
    NSLog(@"Writing output PNG to %@", output_path);
    [painter writeToPNG:output_path];
    [painter release];

    [pool release];
}

- (NSString *)description
{
    if(!dna) return @"Uninitialised Image Evolver";
    return [dna description];
}

- (void)dealloc
{
    if(dna) [dna release];
    if(target_image) [target_image release];
    
    [super dealloc];
}

@end
