#import "EIColor.h"

@implementation EIColor : NSObject

- (unsigned char)red
{
    return r;
}

- (unsigned char)green
{
    return g;
}

- (unsigned char)blue
{
    return b;
}

- (unsigned char)alpha
{
    return a;
}

- (void)setRed:(unsigned char)red
{
    r = red;
}

- (void)setGreen:(unsigned char)green
{
    g = green;
}

- (void)setBlue:(unsigned char)blue
{
    b = blue;
}

- (void)setAlpha:(unsigned char)alpha
{
    a = alpha;
}


- (NSString *)description
{
    return @"Color";
}

@end
