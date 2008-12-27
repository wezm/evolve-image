#import <Foundation/Foundation.h>
#import "EIDna.h"
#import "EICairoPNGImage.h"

#define NUM_POLYGONS 50
#define NUM_POLYGON_POINTS 6

@interface EIImageEvolver : NSObject {
    unsigned int num_threads;
    EICairoPNGImage *target_image;
    EIDna *dna;
    long fitness;
    NSLock *dna_lock;
}

- (int)evolveToTargetImageAtPath:(NSString *)path;

// Private
- (void)evolve;

@end
