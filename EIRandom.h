
@protocol EIRandom

// Returns the single shared instance of this class
+ (id)sharedInstance;

// Return a psuedo-random decimal number between 0, 1
- (double)nextValue;

@end

