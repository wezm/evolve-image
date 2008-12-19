#import <Foundation/Foundation.h>
#import "mtwist.h"

@interface EIDna : NSObject {
    NSArray *polygons;
    mt_state *rand_state;
	int width;
	int height;
}

- (id)initWithPolygons:(int)num_polygons withPoints:(int)num_points;
- (void)mutate;
- (int)width;
- (int)height;

@end
