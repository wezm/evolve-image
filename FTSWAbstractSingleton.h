#import <Foundation/Foundation.h>

// From: http://www.cocoadev.com/index.pl?FTSWAbstractSingleton

@interface FTSWAbstractSingleton : NSObject {
}
+ (id)singleton;
+ (id)singletonWithZone:(NSZone*)zone;

//designated initializer, subclasses must implement and call supers implementation
- (id)initSingleton; 
@end
