#import <Foundation/Foundation.h>
#import "EIDna.h"

#define NUM_POLYGONS 50
#define NUM_POLYGON_POINTS 6

@interface EIImageEvolver : NSObject {
    NSArray *dna;
}

- (int)runWithThreads:(int)threads;

@end
