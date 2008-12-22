#import <Foundation/Foundation.h>
#import "EIDna.h"
#import "EICairoPNGImage.h"

#define NUM_POLYGONS 50
#define NUM_POLYGON_POINTS 6

@interface EIImageEvolver : NSObject {
    NSArray *dna;
    EICairoPNGImage *target_image;
}

- (id)initWithTargetImage:(NSString *)path;
- (int)runWithThreads:(int)threads;

// Private
- (void)evolveWithDna:(EIDna *)helix;

@end
