#import <Foundation/Foundation.h>
#import "EIDna.h"
#import "EICairoImage.h"

#define NUM_POLYGONS 50
#define NUM_POLYGON_POINTS 6

@interface EIImageEvolver : NSObject {
    NSArray *dna;
    EICairoImage *target_image;
}

- (id)initWithTargetImage:(NSString *)path;
- (int)runWithThreads:(int)threads;

@end
