#import <Foundation/Foundation.h>

@interface EIColor : NSObject {
    unsigned char r;
    unsigned char g;
    unsigned char b;
    unsigned char a;
}

- (unsigned char)red;
- (unsigned char)green;
- (unsigned char)blue;
- (unsigned char)alpha;

- (void)setRed:(unsigned char)red;
- (void)setGreen:(unsigned char)green;
- (void)setBlue:(unsigned char)blue;
- (void)setAlpha:(unsigned char)alpha;

@end
