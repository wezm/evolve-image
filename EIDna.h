#import <Foundation/Foundation.h>
#import "EIImage.h"

@interface EIDna : NSObject {
    NSArray *polygons;
    //EIMersenneTwister *twister;
    id twister;
	EIImage *target_image;
}

- (id)initWithPolygons:(int)num_polygons withPoints:(int)num_points;
- (void)mutate;

@end
