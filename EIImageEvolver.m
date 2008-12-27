#import "EIImageEvolver.h"
#import "EITypes.h"
#import "EIPolygon.h"
#import "EICairoDnaPainter.h"
#import <stdlib.h>

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
        dna_lock = [[NSLock alloc] init];
    }

    return self;
}

- (int)evolveToTargetImageAtPath:(NSString *)path;
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EIBounds bounds;

    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"Target image: %@ does not exist", path);
        return 1;
    }

    target_image = [[EICairoPNGImage alloc] initWithPath:path];

    // Ensure the target image is in ARGB32 format
    [target_image changeToFormat:CAIRO_FORMAT_ARGB32]; // TODO: change this method to setFormat:

    bounds.width = [target_image width];
    bounds.height = [target_image height];

	// Set the best fitness so far to target minus nothing (i.e. the sum of
	// the target)
	fitness = [target_image sum];

    // Create polygons for the DNA to manipulate
    NSMutableArray *polygons = [[NSMutableArray alloc] initWithCapacity:NUM_POLYGONS];
    for(int j = 0; j < NUM_POLYGONS; j++)
    {
        EIPolygon *polygon = [[EIPolygon alloc] initWithPoints:NUM_POLYGON_POINTS];
        [polygons addObject:polygon];
        [polygon release];
    }
    dna = [[EIDna alloc] initWithPolygons:polygons withinBounds:bounds];
    [polygons release];
	[dna randomisePolygons];

    NSMutableArray *threads = [[NSMutableArray alloc] init];
	for(int i = 0; i < num_threads; i++)
    {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(evolve) object:nil];
		[thread setName:[NSString stringWithFormat:@"evolver%d", i]];
        [threads addObject:thread];
    }

    // Start the threads!
    [threads makeObjectsPerformSelector:@selector(start)];

	EICairoDnaPainter *painter = [[EICairoDnaPainter alloc] initWithBounds:bounds];
    NSLog(@"Waiting");
	int seconds = 0;
    while(1)
    {
        [NSThread sleepForTimeInterval:5];
        //sleep(1);
		[dna_lock lock];
		[painter paintDna:dna];
		[dna_lock unlock];
		[painter writeToPNG:[[self desktopPath] stringByAppendingPathComponent:@"best.png"]];
		
		seconds += 5;
		NSLog(@"%d", seconds);
    }

	[painter release];

    // Stop the threads
    [threads makeObjectsPerformSelector:@selector(cancel)];

    // Wait for them all to finish
    int unfinished = [threads count];
    while(unfinished != 0)
    {
        unfinished = 0;
        NSEnumerator *iter = [threads objectEnumerator];
        NSThread *thread;
        while((thread = [iter nextObject]) != nil)
        {
            if(![thread isFinished]) unfinished++;
        }

        // Wait 100ms before trying again
        [NSThread sleepForTimeInterval:0.1];
    }
    [threads release];

    NSLog(@"Best fitness: %ld", fitness);

    [pool release];
    return 0;
}

- (void)evolve
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EIBounds bounds;
    bounds.width = [target_image width];
    bounds.height = [target_image height];
    EICairoDnaPainter *painter = [[EICairoDnaPainter alloc] initWithBounds:bounds];

    // Main evolution loop
    unsigned int mutation_count = 0;
    while(![[NSThread currentThread] isCancelled])
    {
        // Nested autorelease pool so that we don't go accumulating thousands
        // of images (from the painter)
        NSAutoreleasePool *lap_pool = [[NSAutoreleasePool alloc] init];
		[dna_lock lock];
		EIDna *helix = [dna copy];
		[dna_lock unlock];
			
        [helix mutate];
		// NSLog(@"%@", helix);
        [painter paintDna:helix];
        
        long helix_fitness = [target_image difference:[painter image]];

        [dna_lock lock];
        if(helix_fitness < fitness)
        {
            NSLog(@"beneficial mutation %ld -> %ld", fitness, helix_fitness);
            fitness = helix_fitness;
			[dna release];
			dna = [helix retain];
        }
		[helix release];
        [dna_lock unlock];

        mutation_count++;
		// if([helix index] == 0)
		// {
		// 	NSLog(@"mutation %d", mutation_count);
		// }
        [lap_pool release];
    }
    NSLog(@"%u mutations", mutation_count);

    [painter release];
    [pool release];
}

// TODO: Make into a category on NSFileManager
- (NSString *)desktopPath
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *desktop;
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
        desktop = [NSString stringWithString:NSHomeDirectory()];
    }

    NSFileManager *file_manager = [NSFileManager defaultManager];
    if(![file_manager fileExistsAtPath:desktop])
    {
        // Create the Desktop directory
        if(![file_manager createDirectoryAtPath:desktop attributes:nil])
        {
            NSLog(@"Unable to create Desktop: %@", desktop);
			return nil;
        }
    }

	[desktop retain];
	[pool release];
	return [desktop autorelease];
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
    if(dna_lock) [dna_lock release];

    [super dealloc];
}

@end
