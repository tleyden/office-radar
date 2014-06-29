

#import <Foundation/Foundation.h>

@interface RDUserHelper : NSObject

// Singleton
+ (id)sharedInstance;

// Get the user id of the logged in user, if any.  Otherwise return nil.
- (NSString *)loggedInUserId;

@end
