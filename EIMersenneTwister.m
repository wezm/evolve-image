#import "EIMersenneTwister.h"
#import <fcntl.h>
#import <stdlib.h>

@implementation EIMersenneTwister

+ (id)sharedInstance
{
	static EIMersenneTwister *shared_instance = nil;
	
	@synchronized([EIMersenneTwister class])
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
		pregen_size = dsfmt_get_min_array_size();
		
		// The array must be aligned, malloc does this on FreeBSD & Mac OS X
		pregen_values = malloc(sizeof(double) * pregen_size);
		if(pregen_values == NULL)
		{
			[self release];
			return nil;
		}
		
		if(![self seed])
        {
            NSLog(@"Unable to seed Mersenne Twister");
            [self release];
            return nil;
        }
		
		// Will force pregen when nextValue is first called
		current_value = pregen_size;
	}
	
	return self;
}

- (double)nextValue
{
	if(current_value >= pregen_size)
	{
		dsfmt_fill_array_close_open(&dsfmt_state, pregen_values, pregen_size);
		current_value = 0;
	}

	return pregen_values[current_value++];	
}

// - (unsigned int)integerValue
// {
// 	return (int)[self doubleValue];	
// }

- (void)dealloc
{
	if(pregen_values) free(pregen_values);
	[super dealloc];
}

// Private

- (BOOL)seed
{
	uint32_t seeds[SEED_SIZE];
	size_t num_read;
	
	// Read SEED_SIZE uint_32's from /dev/urandom
	FILE *dev_random = fopen(RANDOM_DEV_PATH, "r");
	if(dev_random == NULL)
	{
		NSLog(@"Unable to open %s", RANDOM_DEV_PATH);
		return NO;
	}
	num_read = fread(seeds, sizeof(uint32_t), SEED_SIZE, dev_random);
	if(num_read != SEED_SIZE)
	{
        NSLog(@"Problem reading random seed from %s", RANDOM_DEV_PATH);
		return NO;
	}
	fclose(dev_random);
		
	dsfmt_init_by_array(&dsfmt_state, seeds, SEED_SIZE);
	return YES;
}

@end

