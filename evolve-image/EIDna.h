#import <Foundation/Foundation.h>
#import "EIMersenneTwister.h"

@interface EIDna : NSObject {
    NSArray *polygons;
    EIMersenneTwister *twister;
	int width;
	int height;
}

- (id)initWithPolygons:(int)num_polygons withPoints:(int)num_points;
- (void)mutate;
- (int)width;
- (int)height;

@end
