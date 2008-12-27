#import <Foundation/Foundation.h>
#import "EIPolygon.h"
#import "EICairoImage.h"
#import <cairo.h>
#import "EICairoImage.h"
#import "EITypes.h"
#import "EIDna.h"

// Class to paint a DNA object using a cairo context
@interface EICairoDnaPainter : NSObject {
	EIBounds bounds;
    cairo_t *context;
}

- (id)initWithBounds:(EIBounds)new_bounds;
- (void)paintDna:(EIDna *)dna;
- (void)paintPolygon:(EIPolygon *)polygon;
- (void)writeToPNG:(NSString *)path;
- (EICairoImage *)image;

@end

