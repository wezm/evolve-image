#import <Foundation/Foundation.h>
#import "EIColor.h"

@interface EIPolygon : NSObject {
    EIColor *color;
    NSArray *points;
}

- (id)initWithPoints:(int)num_points;
- (int)verticesCount;

@end
