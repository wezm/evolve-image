#import <Foundation/Foundation.h>
#import "mtwist.h"

@interface EIDna : NSObject {
    NSArray *polygons;
    mt_state *rand_state;
}

- (id)initWithPolygons:(int)num_polygons withPoints:(int)num_points;
- (void)mutate;
- (unsigned int)randIntUpto:(unsigned int)max;

@end
