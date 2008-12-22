#import "EIRand.h"
#import <time.h>
#import <stdlib.h>
#import <limits.h>

@implementation EIRand : NSObject

- (id)init
{
    if((self = [super init]) != nil)
    {
       srand(time(NULL));
    }

    return self;
}

- (double)nextValue
{
    unsigned int value = (unsigned int)rand();

    // Map to 0, 1
    return value / (double)UINT_MAX;
}

@end

