#import <Foundation/Foundation.h>
#import "EIImageEvolver.h"

int main (void)
{
    int exit_status;

    EIImageEvolver *evolver = [[EIImageEvolver alloc] init];

    NSLog (@"Executing");
    exit_status = [evolver runWithThreads:2];

    NSLog(@"%@", evolver);

    [evolver release];

    return exit_status;
}

