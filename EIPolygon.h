#import <Foundation/Foundation.h>
#import "EITypes.h"

@interface EIPolygon : NSObject <NSCopying> {
    EIColor *color;
    EIPoint *points;
	int points_count;
}

- (id)initWithPoints:(int)num_points;
- (int)verticesCount;
- (EIColor *)color;
- (void)setColor:(EIColor *)new_color;
- (EIPoint *)points;
- (void)setPoints:(EIPoint *)new_points;

@end
