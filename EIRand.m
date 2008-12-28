#import "EIRand.h"
#import <time.h>
#import <stdlib.h>
#import <unistd.h>

@implementation EIRand

+ (id)sharedInstance
{
	static EIRand *shared_instance = nil;
	
	@synchronized([EIRand class])
	{
		if(shared_instance == nil)
		{
			shared_instance = [self singleton];
		}
	}
	
	return shared_instance;
}

- (id)initSingleton
{
    if((self = [super initSingleton]) != nil)
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

