#import <Foundation/Foundation.h>
#import "EIDna.h"
#import "EICairoPNGImage.h"

#define NUM_POLYGONS 50
#define NUM_POLYGON_POINTS 6

@interface EIImageEvolver : NSObject {
    unsigned int num_threads;
    NSArray *dna;
    EICairoPNGImage *target_image;
}

- (int)evolveToTargetImageAtPath:(NSString *)path;
- (unsigned long)compareTargetImageTo:(EICairoImage *)image;

// Private
- (void)evolveDna:(EIDna *)helix;

@end
