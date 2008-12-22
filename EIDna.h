#import <Foundation/Foundation.h>
#import "EITypes.h"

@interface EIDna : NSObject {
    NSArray *polygons;
    //EIMersenneTwister *twister;
    id twister;
    EIBounds bounds;

}

- (id)initWithPolygons:(NSArray *)dna_polygons withinBounds:(EIBounds)dna_bounds;
- (void)mutate;

@end
