#import <Foundation/Foundation.h>
#import "EITypes.h"

@interface EIDna : NSObject {
    NSArray *polygons;
    //EIMersenneTwister *twister;
    id twister;
    EIBounds bounds;
	int index;
}

- (id)initWithPolygons:(NSArray *)dna_polygons withinBounds:(EIBounds)dna_bounds;
- (void)mutate;
- (NSArray *)polygons;
- (EIBounds)bounds;
- (void)setIndex:(int)dna_index;
- (int)index;

@end
