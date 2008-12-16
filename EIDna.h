#import <Foundation/Foundation.h>
#import "EIPolygon.h"

@interface EIDna : NSObject {
    NSArray *polygons;
}

- (id)initWithPolygons:(int)num_polygons withPoints:(int)num_points;

@end
