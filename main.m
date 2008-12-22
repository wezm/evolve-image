#import <Foundation/Foundation.h>
#import "EIImageEvolver.h"

int main (void)
{
    int exit_status;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    EIImageEvolver *evolver = [[EIImageEvolver alloc] initWithTargetImage:@"/Users/wmoore/Desktop/mona_lisa_crop.png"];

    NSLog (@"Executing");
    exit_status = [evolver runWithThreads:2];

    //NSLog(@"%@", evolver);

    [evolver release];

	[pool release];
    return exit_status;
}

