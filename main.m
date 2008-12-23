#import <Foundation/Foundation.h>
#import "EIImageEvolver.h"

int main(int argc, const char *argv[])
{
    int exit_status;

    if(argc < 2)
    {
        NSLog(@"Usage: EvolveImage target_image.png");
        return EXIT_FAILURE;
    }

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *target_path = [NSString stringWithUTF8String:argv[1]];
    EIImageEvolver *evolver = [[EIImageEvolver alloc] initWithTargetImage:target_path];

    if(!evolver)
    {
        NSLog(@"Problem initialising ImageEvolver");
        [pool release];
        return EXIT_FAILURE;
    }

    NSLog (@"Executing");
    exit_status = [evolver runWithThreads:2];

    //NSLog(@"%@", evolver);

    [evolver release];

    [pool release];
    return exit_status;
}

