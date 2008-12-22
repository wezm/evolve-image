#import <Foundation/Foundation.h>
#import "EICairoImage.h"

// TODO: This should be a category on EICairoImage

#ifndef CAIRO_HAS_PNG_FUNCTIONS
#error Cairo does not have required PNG support
#endif

@interface EICairoPNGImage : EICairoImage

- (id)initWithPath:(NSString *)image_path;

@end
