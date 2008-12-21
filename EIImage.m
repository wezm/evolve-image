#import "EIImage.h"

@implementation EIImage : NSObject

- (id)initWithPath:(NSString *)image_path
{
	if((self = [super init]) != nil)
	{
		path = [image_path retain];
	}
	
	return self;
}

- (int)width
{
	return 0;
}

- (int)height
{
	return 0;
}

@end
