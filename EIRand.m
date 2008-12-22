#import "EIRand.h"
#import <time.h>
#import <stdlib.h>
//#import <limits.h>
#import <unistd.h>

@implementation EIRand : NSObject

- (id)init
{
    if((self = [super init]) != nil)
    {
        pid_t pid = getpid();
        srand(time(NULL) * (unsigned int)pid);
    }

    return self;
}

- (double)nextValue
{
    unsigned int value = (unsigned int)rand();

    // Map to 0, 1
    return value / (double)RAND_MAX;
}

@end

