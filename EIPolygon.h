#import <Foundation/Foundation.h>
#import "EITypes.h"

@interface EIPolygon : NSObject {
    EIColor *color;
    EIPoint *points;
	int points_count;
}

- (id)initWithPoints:(int)num_points;
- (int)verticesCount;
- (EIColor *)color;
- (EIPoint *)points;

@end
