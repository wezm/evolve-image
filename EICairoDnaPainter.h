#import <Foundation/Foundation.h>
#import "EIDna.h"
#import <cairo.h>

// Class to paint a DNA object using a cairo context
@interface EICairoDnaPainter : NSObject {
    EIDna *dna;
    cairo_t *context;
}

- (id)initWithDna:(EIDna *)new_dna;
- (void)paint;

@end

