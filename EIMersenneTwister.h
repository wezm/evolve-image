#import <Foundation/Foundation.h>
#import "dSFMT.h"

#define SEED_SIZE 100
#define RANDOM_DEV_PATH "/dev/urandom"

@interface EIMersenneTwister : NSObject {
	double *pregen_values;
	int pregen_size;
	int current_value;
	dsfmt_t dsfmt_state;
}

- (double)nextValue;
//- (unsigned int)integerValue;
- (BOOL)seed;

@end