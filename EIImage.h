#import <Foundation/Foundation.h>

@interface EIImage : NSObject {
	NSString *path;
	int width;
	int height;
}

- (id)initWithPath:(NSString *)image_path;
- (int)width;
- (int)height;

@end
